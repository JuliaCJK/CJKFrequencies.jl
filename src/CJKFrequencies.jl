module CJKFrequencies

using LightXML
using DataStructures
using Pkg.Artifacts

export CharacterFrequency, charfreq,

SimplifiedLCMC, SimplifiedJunDa


const CharacterFrequency = Accumulator{String, Int64}

"""
    charfreq(text)
    charfreq(charfreq_type)

Create a character frequency mapping from either text or load it from a default location for
pre-specified character frequency datasets (e.g. `SimplifiedLCMC`, `SimplifiedJunDa`, etc.).
"""
function charfreq end
charfreq(text) = CharacterFrequency(counter(text))


include("frequency_datasets.jl")


end