
"""
Accumulator-like data structure for storing frequencies of CJK words 
(although other tokens can be stored as well). 
This is usually like the type `Accumulator{String, Int}`.

You generally don't need to explicitly call this struct's constructor yourself; 
rather, use the `charfreq` function.
"""
struct CJKFrequency{S <: AbstractString, C <: Number}
    freq::Accumulator{S, C}
    size::Ref{C}
    
    function CJKFrequency{S, C}(freq::Accumulator{S, C}) where {S <: AbstractString, C <: Number}
        new(freq, Ref(sum(values(freq))))
    end
end

function CJKFrequency(frequencies=Dict{String, Int}())
    key_type = eltype(keys(frequencies))
    val_type = eltype(values(frequencies))
    CJKFrequency{key_type, val_type}(counter(frequencies))
end
CJKFrequency(pairs...) = CJKFrequency(Dict(pairs))

# mutation
function DataStructures.inc!(cf::CJKFrequency, key, count=1)
    inc!(cf.freq, key, count)
    cf.size[] += count
end
function DataStructures.dec!(cf::CJKFrequency, key, count=1)
    if key in keys(cf.freq)
        cf.size[] -= cf.freq[key] - max(0, cf.freq[key] - count)
        dec!(cf.freq, key, min(count, cf.freq[key]))
    end
end
function DataStructures.reset!(cf::CJKFrequency, key)
    key in keys(cf.freq) && (size[] -= cf.freq[key])
    reset!(cf.freq, key)
end

# collections operations
Base.isempty(cf::CJKFrequency) = isempty(cf.freq)
function Base.empty!(cf::CJKFrequency)
     empty!(cf.freq)
     size = 0
     return cf
end
Base.in(item, cf::CJKFrequency) = in(item, cf.freq)

# dictionaries
Base.haskey(cf::CJKFrequency, key) = haskey(cf.freq, key)
Base.keys(cf::CJKFrequency) = keys(cf.freq)
Base.values(cf::CJKFrequency) = values(cf.freq)

# indexing
Base.getindex(cf::CJKFrequency, i) = getindex(cf.freq, i)
Base.firstindex(cf::CJKFrequency) = firstindex(cf.freq)
Base.lastindex(cf::CJKFrequency) = lastindex(cf.freq)
function Base.setindex!(cf::CJKFrequency, value, key)
    cf.freq[key] = value
    cf
end

# iteration
Base.iterate(cf::CJKFrequency) = iterate(cf.freq)
Base.iterate(cf::CJKFrequency, state) = iterate(cf.freq, state)
Base.length(cf::CJKFrequency) = length(cf.freq)
Base.size(cf::CJKFrequency) = cf.size[]

Base.copy(cf::CJKFrequency{S, C}) where {S, C} = CJKFrequency{S, C}(copy(cf.freq))

# set operations
function Base.intersect(cf::CJKFrequency, cfs::Vararg{CJKFrequency})
    out = CJKFrequency(Dict([char => cf[char] for char in intersect(keys(cf), map(keys, cfs)...)]))
    for list in cfs
        for (char, freq) in list
            if char in keys(out)
                out[char] = min(out[char], freq)
            end
        end
    end
    out
end
function Base.union(cf::CJKFrequency, cfs::Vararg{CJKFrequency})
    out = CJKFrequency(Dict([char => cf[char] for char in union(keys(cf), map(keys, cfs)...)]))
    for list in cfs
        for (char, freq) in list
            out[char] = max(out[char], freq)
        end
    end
    out
end

"""
    charfreq(text)
    charfreq(charfreq_type)

Create a character frequency mapping from either text or load it from a default location for
pre-specified character frequency datasets (e.g. `SimplifiedLCMC`, `SimplifiedJunDa`, etc.).

## Examples
When creating a character frequency from text, this method behaves almost exactly like
`DataStructures.counter` except that the return value always has type `CharacterFrequency`
(`Accumulator{String, Int}`).
```julia-repl
julia> text = split("王老师性格内向，沉默寡言，我除在课外活动小组“文学研究会”听过他一次报告，并听-邓知识渊博，是“老师的老师”外，对他一无所知。所以，研读他的作", "");

julia> charfreq(text)
CJKFrequency{SubString{String}, Int64}(Accumulator(除 => 1, 报 => 1, 是 => 1, 知 => 2, 并 => 1, 性 => 1, ， => 6, 言 => 1, 邓 => 1, 外 => 2, 所 => 2, 对 => 1, 动 => 1, 寡 => 1, 。 => 1, 渊 => 1, 学 => 1, - => 1, 听 => 2, 我 => 1, 次 => 1, 一 => 2, 读 => 1, 作 => 1, 格 => 1, “ => 2, 博 => 1, 课 => 1, 老 => 3, 会 => 1, 告 => 1, 无 => 1, 活 => 1, 组 => 1, 内 => 1, 师 => 3, 的 => 2, 小 => 1, 文 => 1, 默 => 1, 究 => 1, 过 => 1, 在 => 1, 以 => 1, ” => 2, 研 => 2, 他 => 3, 向 => 1, 沉 => 1, 王 => 1), Base.RefValue{Int64}(71))
```

See the documentation for individual character frequency dataset structs for examples of the
second case.
"""
function charfreq end
charfreq(tokens) = CJKFrequency(counter(tokens))
charfreq(text::AbstractString) = CJKFrequency(counter(split(text, "")))
charfreq(cf::CJKFrequency) = cf

"""
    entropy(charfreq)

Compute the information theoretic entropy for a character frequency,
defined as

\$-\\sum_{(c, v)\\in CF} \\frac{v}{s}\\log_2\\left( \\frac{v}{s} \\right), \\quad s=\\sum_{(c, v) \\in CF} v\$

where \$c\$ is the character and \$v\$ is the count for that value.
"""
entropy(cf::CJKFrequency) = -sum(values(cf.freq)) do count
    prob = count / cf.size[]
    prob * log2(prob)
end


