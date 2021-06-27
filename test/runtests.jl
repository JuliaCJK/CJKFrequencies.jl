using CJKFrequencies

using Test

@testset "all tests" begin
    include("charfreq_tests.jl")
    include("freq_datasets_tests.jl")
    include("lexicon_tests.jl")
end
