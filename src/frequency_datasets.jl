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
A character frequency dataset: Lancaster Corpus for Mandarin Chinese, simplified terms only,
based on simplified text corpus.

The character frequency can be based only on selected categories (see `lcmc_categories` for valid
 category keys and corresponding category names).
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
        words_from_xml(root(doc), cf)
    end
    cf
end

function words_from_xml(xml_elem, accum)
    for c in child_nodes(xml_elem)
        if name(c) == "w"
            inc!(accum, content(c))
        else
            words_from_xml(c, accum)
        end
    end
end


#==============================================================================#
#=                             Simplified Jun Da                              =#
#==============================================================================#
"""
A character frequency dataset: compiled by Jun Da, simplified single-character words only.

Source: https://lingua.mtsu.edu/chinese-computing/statistics/char/list.php?Which=MO
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

