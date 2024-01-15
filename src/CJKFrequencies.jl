module CJKFrequencies

using LightXML
using DataStructures
using LazyArtifacts

export CJKFrequency, charfreq,

SimplifiedLCMC, 
SimplifiedJunDa,
TraditionalHuangTsai,
SimplifiedLeidenWeibo,
SimplifiedSUBTLEX,

Lexicon, tagged_with


include("charfreq.jl")
include("frequency_datasets.jl")
include("lexicon.jl")


end
