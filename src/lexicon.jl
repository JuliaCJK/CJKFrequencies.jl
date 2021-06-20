
struct Lexicon
    words::Dict{String, Set{String}}
    tags::Set{String}
end

"""
    Lexicon()
    Lexicon(io_or_filename)
    Lexicon(words)

Construct a lexicon. It can be empty (no parameters) or created from some IO-like object or a
sequence/iterable of words.

A lexicon is a list of (known) words, each of which can be tagged with various tags (e.g.
indicating how it is known, etc.).
"""
function Lexicon end

Lexicon(words) = Lexicon(Dict(word => Set{String}() for word in words), Set{String}())
Lexicon() = Lexicon(Dict{String, Set{String}}(), Set{String}())

function Lexicon(io::Union{IO, AbstractString})
    lex = Lexicon()
    for line in eachline(io)
        char, tag_string = split(line, ":")
        tags = split(tag_string, ",")
        push!(lex, char; tags)
    end
    lex
end

Base.length(lex::Lexicon) = length(lex.words)
Base.in(item, lex::Lexicon) = haskey(lex.words, item)
Base.getindex(lex::Lexicon, index) = getindex(lex.words, index)
Base.print(io::IO, lex::Lexicon) =
    for (word, tags) in lex.words
        println(io, "$word:$(join(tags, ","))")
    end

function Base.push!(lex::Lexicon, words...; tags=())
    for word in words
        haskey(lex.words, word) || (lex.words[word] = Set{String}())
        for tag in tags
            push!(lex.words[word], tag)
        end
    end
    for tag in tags
        push!(lex.tags, tag)
    end
    nothing
end

taggedwith(lex::Lexicon, tag) =
    [word for (word, tags) in lex.words if tag in tags]


"""
    coverageof(lexicon, charfreq)
    coverageof(lexicon, text)

Compute a lexicon's coverage of a text (possibly via a precomputed character
frequency dictionary). Both token and type coverage are provided.
"""
function coverage(lex::Lexicon, cf::Accumulator)
    known_tokens, total_tokens, known_types, total_types = 0, 0, 0, length(lex)
    for (char, freq) in cf
        if char in lex
            known_tokens += freq
            known_types += 1
        end
        total_tokens += freq
        total_types += 1
    end
    (char_coverage=Float(known_tokens)/total_tokens, type_coverage=Float(known_types)/total_types)
end
coverage(lex::Lexicon, text) = coverage(charfreq(text), lex)

