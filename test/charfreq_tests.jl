
@testset "char freq from text" begin
    test_text = "十七道身影，十七道白色的身影，宛如星丸跳跃一般从山腰处朝山顶方向而来，这十七道身影的主人，年纪最小的也超过了五旬，一个个神色凝重，他们身穿的白袍代表的是内门，而胸前那金色的唐字则是唐门长老的象征。"

    cf = charfreq(test_text)

end

@testset "char freq from iterable" begin
    tokens = ["a", "b", "a", "c", "b", "a", "c", "b", "a"]
    cf = charfreq(tokens)

    @assert "a" in keys(cf)
    @assert "b" in keys(cf)
    @assert "c" in keys(cf)

end
