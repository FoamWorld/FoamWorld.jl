abstract type Block end
id(b::Block)=String(typeof(b).name.name)
stack(::Block)=0x4
c_use(::Block)=false
function i_show(i::Block,con;theme=:slategray)
	clear_rect(con,0,0;color=theme)
	i_show_l(i,con)
end
function i_show_l(i::Block,con)
	iid=id(i)
	if haskey(loadedimgs,iid)
		so=@inbounds loadedimgs[iid]
	else
		so=loadedimgs["notexture"]
	end
	fill_image(con,so,0,0)
end
function b_show(b::Block,con,x::Int,y::Int)
	bid=id(b)
	if haskey(loadedimgs,bid)
		so=@inbounds loadedimgs[iid]
	else
		so=loadedimgs["notexture"]
	end
	fill_image(con,so,x,y)
end
function hard(b::Block)
	bid=id(b)
	if haskey(硬度dict,bid)
		return 硬度dict[bid]::UInt8
	end
	return 0x0
end
light(::Block)=0x0
hole(::Block)=false
e_put(::Block,::Int,::Int)=nothing
exist(::Block,::Int,::Int)=nothing
e_exist(::Block,::Int,::Int)=nothing
function li_show(b::Block,x::Int,y::Int)
	li::UInt8=light(b)
	if li==0x0 return end
end
upd(::Block)=nothing

abstract type 气体<:Block end
abstract type 液体<:Block end
colbox(::Union{气体,液体},x::Int,y::Int)=EmptyCollisionBox()
hard(::Union{气体,液体})=zero(UInt)
struct 虚无<:气体 end
b_show(::虚无,con,x::Int,y::Int)=fill_rect(con,x,y;color=:black)
struct 空气<:气体 end # 进行特殊处理
li_show(::空气,x::Int,y::Int)=nothing
include("水.jl")
include("岩浆.jl")

abstract type 固体<:Block end
colbox(::固体,x::Int,y::Int)=BCollisionBox(x,y,x+1,y+1)
struct 星岩<:固体 end
struct 玻璃<:固体 end
struct 沙子<:固体 end

abstract type 岩石<:固体 end
struct 石头<:岩石 end
struct 花岗岩<:岩石 end
struct 安山岩<:岩石 end
struct 玄武岩<:岩石 end
struct 闪长岩<:岩石 end
struct 黑曜岩<:岩石 end
struct 萤石<:岩石 end
light(::萤石)=0xc
