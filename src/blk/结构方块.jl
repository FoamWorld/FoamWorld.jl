mutable struct 结构方块<:固体
	name::String
	x::Int
	y::Int
	w::Int
	h::Int
end
function e_put(b::结构方块,x::Int,y::Int)
	b.x=x
	b.y=y
end
c_use(::结构方块)=true
