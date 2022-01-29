"""
first: 第一次使用时（不会调用init）
init: 使用前操作
gchunk(c,x,y): 区块生成
"""
struct MapGenerator
	first::Function
	init::Function
	gchunk::Function
end
include("_infmaze.jl")
