
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
        push!(lex, char; tags=tags)
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
        if !haskey(lex.words, word)
            lex.words[word] = Set{String}()
        end

        for tag in tags
            push!(lex.words[word], tag)
        end
    end
    for tag in tags
        push!(lex.tags, tag)
    end
    nothing
end

"""
    tagged_with(lexicon, tag)

The set of words or characters in a lexicon tagged with `tag`.
"""
tagged_with(lex::Lexicon, tag) =
    [word for (word, tags) in lex.words if tag in tags]


"""
    coverage([filter,] coverer, covered)

Compute an "intersection-over-latter" coverage metric.

The coverage of a lexicon of known words over a character frequency list is 
the ratio of tokens or types in the frequency list which are also present in the lexicon.
There are two varieties:

- token coverage counts each token separately (considering repeated characters)
- type coverage counts each unique token once

Suppose the lexicon contains all the words you know 
and the frequency list represents words extracted from a text you wish to read.
The token coverage represents how much of the text you are expected to know (by character),
and the type coverage represents how much of the vocabulary you are.
The lower the coverage, the higher the "switching cost" in terms of vocabulary.

Coverage can be computed between 
- lexicon over a frequency list
- lexicon over text (represented as a frequency list)
- frequency list over another frequency list
by both tokens and types.

## Parameters

The first parameter must be a *covering type*, i.e. one of `Accumulator`, `CJKFrequency`, or `Lexicon`.
The second parameter must be a *coverable type*, i.e. either `Accumulator` or `CJKFrequency`.
Anything else must be convertible to `CJKFrequency` via the `charfreq` function.

If three arguments are provided, the first argument acts as a context filter.
This must be a covering type.
For example, if the arguments are a lexicon, frequency list, and some text (in that order),
the coverage of the frequency list over the text will be computed,
ignoring any characters in the text that do not appear in the lexicon.

## Examples

"""
function coverage end

const CoveringType = Union{Accumulator, CJKFrequency, Lexicon}
const CoverableType = Union{Accumulator, CJKFrequency}

function coverage(lex::CoveringType, cf::CoverableType)
    known_tokens, total_tokens, known_types, total_types = 0, 0, 0, 0
    for (char, freq) in cf
        if char in lex
            known_tokens += freq
            known_types += 1
        end
        total_tokens += freq
        total_types += 1
    end
    (token_coverage=Float(known_tokens)/total_tokens, type_coverage=Float(known_types)/total_types)
end
coverage(ct::CoveringType, text) = coverage(ct, charfreq(text))
coverage(text, ct::CoverableType) = coverage(charfreq(text), ct)
coverage(text1, text2) = coverage(charfreq(text1), charfreq(text2))

function coverage(lex::CoveringType, cf1::CoveringType, cf2::CoverableType)
    known_tokens, total_tokens, known_types, total_types = 0, 0, 0, 0
    for (char, freq) in cf2
        if char ∈ lex
            if char in cf1
                known_tokens += freq
                known_types += 1
            end
            total_tokens += freq
            total_types += 1
        end
    end
    (token_coverage=Float(known_tokens)/total_tokens, type_coverage=Float(known_types)/total_types)
end
coverage(lex::CoveringType, ct::CoveringType, text) = coverage(lex, ct, charfreq(text))
coverage(lex::CoveringType, text, ct::CoverableType) = coverage(lex, charfreq(text), ct)
coverage(lex::CoveringType, text1, text2) = coverage(lex, charfreq(text1), charfreq(text2))
coverage(text0, text1, text2) = coverage(charfreq(text0), charfreq(text1), charfreq(text2))


"""
    mutual_information(charfreq1, charfreq2)

Compute the mutual information between two frequency lists.

!!! warning "Subject to refinement"

    Because there's not a good source of information for the joint PMF,
    this function currently approximates it using the average of the two marginal PMFs.
"""
function mutual_information end

function mutual_information(cf1::CoverableType, cf2::CoverableType)
    sum(keys(cf1) ∩ keys(cf2)) do char
        prob_1 = cf1[char] / cf1.size[]
        prob_2 = cf2[char] / cf2.size[]
        joint = (prob_1 + prob_2) / 2
        joint * log2(joint / prob_1 / prob_2)
    end
end
mutual_information(cf1, cf2) = mutual_information(charfreq(cf1), charfreq(cf2))
