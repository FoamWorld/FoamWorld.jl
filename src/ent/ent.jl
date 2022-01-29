abstract type Entity end

abstract type 生物 end
mutable struct 玩家<:生物
	x::Float64
	y::Float64
	θ::Float64
	health::Int
	its::IB
end
