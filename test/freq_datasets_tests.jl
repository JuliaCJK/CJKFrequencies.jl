
@testset "load lcmc w/ no errors" begin
    lcmc_cf = charfreq(SimplifiedLCMC())
    @test length(lcmc_cf) != 0
end

@testset "load junda w/ no errors" begin
    junda_cf = charfreq(SimplifiedJunDa())
    @test length(junda_cf) != 0
end
