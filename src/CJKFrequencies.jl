module CJKFrequencies

using LightXML
using DataStructures
using LazyArtifacts

export CharacterFrequency, charfreq,

SimplifiedLCMC, SimplifiedJunDa,

Lexicon, taggedwith


include("charfreq.jl")
include("frequency_datasets.jl")
include("lexicon.jl")


end
