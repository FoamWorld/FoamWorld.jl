abstract type 地形生成器 end
exist(::地形生成器)=nothing
init(::地形生成器)=nothing

struct 一片空白<:地形生成器 end
function use(::一片空白,c::Chunk,::Int,::Int)
	for i in 1:64
		for j in 1:64
			c.blks[i,j]=空气()
		end
	end
end
include("_infmaze.jl")
