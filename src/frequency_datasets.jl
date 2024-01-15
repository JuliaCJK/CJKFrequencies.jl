using DelimitedFiles: readdlm


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

- The original corpus is provided primarily for non-profit-making research. Be sure to see the full
  [end user license agreement](https://www.lancaster.ac.uk/fass/projects/corpus/LCMC/lcmc/lcmc_license.htm).
- Via the [Oxford Text Archive](https://ota.bodleian.ox.ac.uk/repository/xmlui/handle/20.500.12024/2474), this corpus is distributed under the [CC BY-NC-SA 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/) license.
"""
struct SimplifiedLCMC
    categories::Set{Char}

    SimplifiedLCMC(cats) =
        new(Set{Char}(cat for cat in uppercase.(cats) if haskey(LCMC_CATEGORIES, cat)))
    SimplifiedLCMC() = new(keys(LCMC_CATEGORIES))
end

function charfreq(lcmc::SimplifiedLCMC)
    cf = CJKFrequency()
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
    SimplifiedJunDa([list])

A character frequency
[dataset](https://lingua.mtsu.edu/chinese-computing/)
 of modern Chinese compiled by Jun Da, for simplified characters.

By default, the modern Chinese list is fetched, 
but this can be set by providing a different `list` argument.
The available lists are as follows:

| List Name                  | Symbol            |
| :------------------------- | :---------------- |
| Modern Chinese (default)   | `:modern`         |
| Classical Chinese          | `:classical`      |
| Modern + Classical Chinese | `:combined`       |
| 《现代汉语常用字表》            | `:common`         |
| News Corpus Bigrams        | `:bigram_news`    |
| Fiction Corpus Bigrams     | `:bigram_fiction` |

Note that although `:classical` uses a Classical Chinese corpus,
it still uses the simplified character set.

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
lists for research and teaching/learning purposes only, no commercial use without permission from
 the author. See their [full disclaimer and copyright notice](https://lingua.mtsu.edu/chinese-computing/copyright.html).
"""
struct SimplifiedJunDa 
    list::Symbol

    SimplifiedJunDa() = new(:modern)
    function SimplifiedJunDa(list::Symbol)
        if list ∉ Set([:modern, :classical, :combined, :common, :bigram_news, :bigram_fiction])
            throw(ArgumentError("unrecognized JunDa list name: $(list)"))
        end

        new(list)
    end
end

function charfreq(config::SimplifiedJunDa)
    cf = CJKFrequency()
    pattern = r"^\d+\s+(\w)\s+(\d+)"
    for line in eachline(joinpath(artifact"junda", "$(string(config.list)).txt"))
        m = match(pattern, line)
        m !== nothing && inc!(cf, m.captures[1], Base.parse(Int, m.captures[2]))
    end
    cf
end


#==============================================================================#
#=                          Traditional Huang-Tsai                            =#
#==============================================================================#

"""
    TraditionalHuangTsai()

A character frequency [dataset](http://technology.chtsai.org/charfreq/) initially created by Shih-Kun Huang
and then further compiled and added to by Chih-Hao Tsai.

The original corpus was collected from 1993-94.

## Licensing/Copyright

Copyright 1996-2006 Chih-Hao Tsai.
Licensing information unknown, so use at your own risk.
"""
struct TraditionalHuangTsai end

function charfreq(::TraditionalHuangTsai)
    cf = CJKFrequency()

    for line in eachline(joinpath(artifact"huang-tsai", "freq.txt"))
        char, count = split(line, limit=2)
        inc!(cf, char, Base.parse(Int, count))
    end

    cf
end


#==============================================================================#
#=                          Simplified Leiden Weibo                           =#
#==============================================================================#

"""
    SimplifiedLeidenWeibo()

A word frequency [dataset](http://lwc.daanvanesch.nl/openaccess.php) built from Weibo messages
This corpus also includes geo-lexical frequency keyed by city,
but this is not included in this character frequency.

This data was collected in 2012.

## Licensing/Copyright

The data is generated from the Leiden Weibo Corpus,
which is released openly under the CC BY-NC-SA 3.0 license.
"""
struct SimplifiedLeidenWeibo end

function charfreq(::SimplifiedLeidenWeibo)
    cf = CJKFrequency()

    for (_, word, _, count) in eachrow(readdlm(joinpath(artifact"leiden-weibo", "freq.txt")))
        inc!(cf, word, count)
    end

    cf
end


#==============================================================================#
#=                           Simplified SUBTLEX-CH                            =#
#==============================================================================#

"""
    SimplifiedSUBTLEX(form)

A word and character frequency [dataset](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0010729) 
generated from film subtitles.
To get the respective frequency list,
pass either `:char` or `:word` for the `form` parameter.

This dataset was published in 2010.

## Licensing/Copyright

The dataset was developed under a non-commercial grant, 
and the researchers have released [free access for research purposes](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0010729#:~:text=Because%20our%20research%20was%20covered%20by%20a%20non%2Dcommercial%20grant%20(see%20the%20acknowledgments)%2C%20we%20can%20give%20free%20access%20to%20the%20outcome%20for%20research%20purposes).
"""
struct SimplifiedSUBTLEX
    form::Symbol

    function SimplifiedSUBTLEX(form::Symbol)
        if form != :char && form != :word
            throw(ArgumentError("`form` argument must be either `:char` or `:word`"))
        end

        new(form)
    end
end

function charfreq(config::SimplifiedSUBTLEX)
    cf = CJKFrequency()
    filename = config.form == :char ? "SUBTLEX-CH-CHR" : "SUBTLEX-CH-WF"

    for (index, line) in eachline(joinpath(artifact"subtlex-ch", filename))
        index <= 3 && continue

        term, count = split(line, limit=2)
        inc!(cf, term, count)
    end

    cf
end
