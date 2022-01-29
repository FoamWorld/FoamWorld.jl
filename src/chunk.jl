mutable struct Chunk
	blks::SMatrix{64,64,Block,4096}
	ligs::SVector{UInt8,2048}
	tm::UInt
end
mutable struct Dimension
	cs::Dict{Complex{Int64},Chunk}
end
mutable struct Game
	ds::Dict{String,Dimension}
	ps::Vector{玩家}
	set::Dict{String,Any}
end
function Game()
	return Game(Dict{String,Dimension}(),Vector{玩家}(),Dict{String,Any}())
end
