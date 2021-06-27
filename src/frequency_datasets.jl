
#==============================================================================#
#=                              Simplified LCMC                               =#
#==============================================================================#

const LCMC_CATEGORIES = Dict(
    'A' => "Press: reportage",
    'B' => "Press: editorials",
    'C' => "Press: reviews",
    'D' => "Religion",
    'E' => "Skills, trades and hobbies",
    'F' => "Popular lore",
    'G' => "Biographies and essays",
    'H' => "Miscellaneous: reports and official documents",
    'J' => "Science: academic prose",
    'K' => "General fiction",
    'L' => "Mystery and detective fiction",
    'M' => "Science fiction",
    'N' => "Adventure and martial arts fiction",
    'P' => "Romantic fiction",
    'R' => "Humour")

"""
    SimplifiedLCMC([categories])

A character frequency dataset: Lancaster Corpus for Mandarin Chinese, simplified terms only,
based on simplified text corpus. See their
[website](https://www.lancaster.ac.uk/fass/projects/corpus/LCMC/default.htm) for more details about the corpus.

The character frequency can be based only on selected categories (see `CJKFrequencies.LCMC_CATEGORIES` for valid
 category keys and corresponding category names). Any invalid categories will be ignored.

## Examples
Loading all the categories:
```julia-repl
julia> charfreq(SimplifiedLCMC())
DataStructures.Accumulator{String,Int64} with 45411 entries:
  "一路…   => 1
  "舍得"   => 9
  "５８"   => 1
  "神农…   => 1
  "十点"   => 8
  "随从"   => 9
  "荡心…   => 1
  "尺码"   => 1
  ⋮      => ⋮
```
Or loading just a subset (argument can be any iterable):
```julia-repl
julia> charfreq(SimplifiedLCMC("ABEGKLMNR"))
DataStructures.Accumulator{String,Int64} with 35488 entries:
  "废…  => 1
  "蜷"  => 1
  "哇"  => 13
  "丰…  => 1
  "弊…  => 3
  "议…  => 10
  "滴"  => 28
  "美…  => 1
  ⋮    => ⋮
```

## Licensing/Copyright
Note: This corpus has some conflicting licensing information, depending on who is supplying the
data.

The original corpus is provided primarily for non-profit-making research. Be sure to see the full
[end user license agreement](https://www.lancaster.ac.uk/fass/projects/corpus/LCMC/lcmc/lcmc_license.htm).

Via the
[Oxford Text Archive](https://ota.bodleian.ox.ac.uk/repository/xmlui/handle/20.500.12024/2474),
this corpus is distributed under the
[CC BY-NC-SA 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/) license.
"""
struct SimplifiedLCMC
    categories::Set{Char}
    function SimplifiedLCMC(cats)
        lcmc = new(Set{String}())
        for cat in cats
            haskey(LCMC_CATEGORIES, cat) && push!(lcmc.categories, cat)
        end
        lcmc
    end
    SimplifiedLCMC() = new(keys(LCMC_CATEGORIES))
end

function charfreq(lcmc::SimplifiedLCMC)
    cf = CharacterFrequency()
    for cat in lcmc.categories
        filename = joinpath(artifact"lcmc", "LCMC_$(cat).XML")
        doc = parse_file(filename)
        _words_from_xml(root(doc), cf)
    end
    cf
end

function _words_from_xml(xml_elem, accum)
    for c in child_nodes(xml_elem)
        if name(c) == "w"
            inc!(accum, content(c))
        else
            _words_from_xml(c, accum)
        end
    end
end


#==============================================================================#
#=                             Simplified Jun Da                              =#
#==============================================================================#
"""
    SimplifiedJunDa()

A character frequency
[dataset](https://lingua.mtsu.edu/chinese-computing/)
 of modern Chinese compiled by Jun Da, simplified single-character
words only.

Currently, only the modern Chinese dataset is fetched; however, in the future, the other lists may
also be provided as an option.

## Examples
```julia-repl
julia> charfreq(SimplifiedJunDa())
DataStructures.Accumulator{String,Int64} with 9932 entries:
  "蜷… => 837
  "哇… => 4055
  "湓… => 62
  "滴… => 8104
  "堞… => 74
  "狭… => 6901
  "尚… => 38376
  "懈… => 2893
  ⋮   => ⋮
```

## Licensing/Copyright
The original author maintains full copyright to the character frequency lists, but provides the
lists for research and taeching/learning purposes only, no commercial use without permission from
 the author. See their full disclaimer and copyright notice [here](https://lingua.mtsu.edu/chinese-computing/copyright.html).
"""
struct SimplifiedJunDa end

function charfreq(::SimplifiedJunDa)
    cf = CharacterFrequency()
    pattern = r"^\d+\s+(\w)\s+(\d+)\s+\d+(?:\.\d+)\s+.+$"
    for line in eachline(joinpath(artifact"junda", "freq.txt"))
        m = match(pattern, line)
        m !== nothing && inc!(cf, m.captures[1], Base.parse(Int, m.captures[2]))
    end
    cf
end

