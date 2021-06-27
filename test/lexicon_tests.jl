
@testset "lexicon plain text IO" begin
    # test basic lexicon reading
    @testset "basic lexicon reading" begin
        lex = Lexicon("res/lexicon-0.txt")
        for elem in ["word", "tagless", "target", "lexicon", "pencil", "pen", "manytags"]
            @test elem in lex
        end
        for elem in ["word", "target", "pencil", "pen"]
            @test elem in tagged_with(lex, "tag2")
        end
        for  elem in ["tagless", "lexicon", "manytags"]
            @test !(elem in tagged_with(lex, "tag2"))
        end
        for tag in ["tag1", "tag2", "meta", "unique", "tag", "another", "more", "evenmore", "lots",
        "toomany"]
            @test tag in lex.tags
        end
        for tag in ["tag", "another", "more", "evenmore", "lots", "toomany"]
            @test tag in lex["manytags"]
        end
    end

    # words and tags with special characters
    @testset "reading lexicons with special chars" begin
        lex = Lexicon("res/lexicon-1.txt")
        for elem in ["with space", "with,comma", "multipart,sentence with both", "word"]
            @test elem in lex
        end
        for tag in ["symbol", "whitespace"]
            @test tag in lex["multipart,sentence with both"]
        end
        @test "spaced tag" in lex["word"]
        @test !("spaced" in lex["word"])
        @test !("tag" in lex["word"])
    end

    # writing and reading a lexicon from file
    @testset "lexicon writing and reading" begin
        lex = Lexicon()
        push!(lex, "command", "exception", "ide", tags=("computer",))
        push!(lex, "don't know where this word comes from")
        push!(lex, "pencil", tags=("stationary",))
        push!(lex, "two category item", tags=("category1", "category2"))

        file = IOBuffer()
        println(file, lex)
        read_lex = Lexicon(file)

        for elem in ["command", "exception", "ide", "pencil"]
            @test elem in lex
        end
        for tag in ["category1", "category2"]
            @test tag in lex["two category item"]
        end
        @test "stationary" in lex["pencil"]
        for elem in ["command", "exception", "ide"]
            @test "computer" in lex[elem]
        end
    end

end

@testset "lexicon IO (other formats)" begin

end

@testset "coverage under lexicon" begin

end
