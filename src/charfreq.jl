
"""
Type representing a character frequency (more for convenience than anything else).
"""
const CharacterFrequency = Accumulator{String, Int}

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
julia> text = split("王老师性格内向，沉默寡言，我除在课外活动小组“文学研究会”听过他一次报告，并听-邓知识渊博，是“老师的老师”外，对他一无所知。所以，研读他的作","");

julia> charfreq(text)
DataStructures.Accumulator{String,Int64} with 51 entries:
  "除… => 1
  "报… => 1
  "是… => 1
  "知… => 2
  "性… => 1
  "外… => 2
  "识… => 1
  "对… => 1
  ⋮   => ⋮
```

See the documentation for individual character frequency dataset structs for examples of the
second case.
"""
function charfreq end
charfreq(text) = CharacterFrequency(counter(text))

