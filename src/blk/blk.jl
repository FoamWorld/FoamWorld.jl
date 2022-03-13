abstract type Block end
id(b::Block)=String(typeof(b).name.name)
text(b::Block)=langs[:name][typeof(b).name.name]
stack(::Block)=0x4
c_use(::Block)=false
use(::Block,::Int,::Int)=nothing
function i_show(i::Block,con)
	if hole(i) clear_rect(con,0,0;color=RGB_(0x70,0x80,0x90)) end
	iid=id(i)
	so=get_loadedimg(iid)
	fill_image(con,so,0,0)
end
function b_show(b::Block,con,x::Int,y::Int)
	bid=id(b)
	so=get_loadedimg(bid)
	fill_image(con,so,x,y)
end
function hard(b::Block)
	bid=id(b)
	if haskey(data[:硬度dict],bid)
		return data[:硬度dict][bid]::UInt8
	end
	return 0x0
end
light(::Block)=0x0
hole(::Block)=false
e_put(::Block,::Int,::Int)=nothing
exist(::Block,::Int,::Int)=nothing
e_exist(::Block,::Int,::Int)=nothing
function li_show(b::Block,x::Int,y::Int,li::UInt8=light(b);arr::SMatrix{31,31,Bool,961})
	if li==0x0 return end
	for i in 1:li<<1|1
		for j in 1:li<<1|1 arr[i,j]=false end
	end
	xq=[0];yq=[0];lq=[li] # 任务队列
	while !isempty(lq)
		xx=popfirst!(xq);yy=popfirst!(yq);l=popfirst!(lq)
		arr[xx+16,yy+16]=true
		tl=getlig(x+xx,y+yy)
		if l<=tl continue end
		setlig(x+xx,y+yy,l)
		if (!transparent(getblk(x+xx,y+yy))&&(xx!=0||yy!=0)) || l==0x1
			continue
		end
		lowl::UInt8=l-0x1
		for i in 1:4
			x0=xx+direx[i];y0=yy+direy[i]
			if !arr[x0+16,y0+16]
				push!(xq,x0)
				push!(yq,y0)
				push!(lq,lowl)
			end
		end
	end
end
upd(::Block)=nothing

abstract type 气体<:Block end
abstract type 液体<:Block end
colbox(::Union{气体,液体},x::Int,y::Int)=EmptyCollisionBox()
hard(::Union{气体,液体})=zero(UInt)
transparent(::Union{气体,液体})=true
struct 虚无<:气体 end
b_show(::虚无,con,x::Int,y::Int)=fill_rect(con,x,y;color=:black)
struct 空气<:气体 end # 进行特殊处理
li_show(::空气,x::Int,y::Int)=nothing
include("水.jl")
include("岩浆.jl")

abstract type 固体<:Block end
colbox(::固体,x::Int,y::Int)=BCollisionBox(x,y,x+1,y+1)
transparent(::固体)=false
struct 星岩<:固体 end
struct 玻璃<:固体 end
transparent(::玻璃)=true
struct 沙子<:固体 end
include("半砖.jl")
include("冰.jl")
include("地毯.jl")
include("告示牌.jl")
include("块.jl")
include("木板.jl")
include("树苗.jl")
include("树叶.jl")
include("箱子.jl")
include("原木.jl")
include("Befunge.jl")

abstract type 岩石<:固体 end
struct 石头<:岩石 end
struct 花岗岩<:岩石 end
struct 安山岩<:岩石 end
struct 玄武岩<:岩石 end
struct 闪长岩<:岩石 end
struct 黑曜岩<:岩石 end
struct 萤石<:岩石 end
light(::萤石)=0xc
