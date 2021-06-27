
@testset "char freq from text" begin
    test_text = "十七道身影，十七道白色的身影，宛如星丸跳跃一般从山腰处朝山顶方向而来，这十七道身影的主人，年纪最小的也超过了五旬，一个个神色凝重，他们身穿的白袍代表的是内门，而胸前那金色的唐字则是唐门长老的象征。"
    cf = charfreq(test_text)

    @test "十" in keys(cf) && cf["十"] == 3
    @test length(cf) == 65
end

@testset "char freq from iterable" begin
    tokens = ["a", "b", "a", "c", "b", "a", "c", "b", "a"]
    cf = charfreq(tokens)

    @test "a" in keys(cf) && cf["a"] == 4
    @test "b" in keys(cf) && cf["b"] == 3
    @test "c" in keys(cf) && cf["c"] == 2

    @test length(cf) == 3
    @test size(cf) == length(tokens)
end
