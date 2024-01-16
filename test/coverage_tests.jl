using CJKFrequencies: coverage, charfreq

@testset "mutual coverage test" begin
    text₁ = "aabbbcdd"
    text₂ = "bccdeeeff"
    cf₁ = charfreq(text₁)
    cf₂ = charfreq(text₂)

    forward_text_coverages = coverage(text₁, text₂)
    forward_cf_coverages = coverage(cf₁, cf₂)
    @test forward_text_coverages.token_coverage == forward_cf_coverages.token_coverage == 4/9
    @test forward_text_coverages.type_coverage == forward_cf_coverages.type_coverage == 0.6

    reverse_text_coverages = coverage(text₂, text₁)
    reverse_cf_coverages = coverage(cf₂, cf₁)
    @test reverse_text_coverages.token_coverage == reverse_cf_coverages.token_coverage == 6/8
    @test reverse_text_coverages.type_coverage == reverse_cf_coverages.type_coverage == 0.75
end
