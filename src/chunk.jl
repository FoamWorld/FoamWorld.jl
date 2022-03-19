mutable struct Chunk
	blks::SMatrix{64,64,Block,4096}
	ligs::SVector{UInt8,2048}
	tm::Int
end
function get_lig(c::Chunk,x::Int,y::Int)::UInt8
	id=(x<<5)|(y>>1)+1
	return (y&1==0) ? c.ligs[id]>>4 : c.ligs[id]&0xf
end
function set_lig(c::Chunk,x::Int,y::Int,v::UInt8)::UInt8
	id=(x<<5)|(y>>1)+1
	(y&1==0) ? c.ligs[id]=c.ligs[id]&0xf|(v<<4) : c.ligs[id]=c.ligs[id]&0xf0|v
end
function generate(c::Chunk,x::Int,y::Int;map_generator::MapGenerator)
	map_generator.gchunk(c,x,y)
	if haskey(sav,Pair(x,y))
		t=@inbounds sav[Pair(x,y)]
		for i in t
			x0=i.first>>6
			y0=i.first&63
			c.bs[x0,y0]=i.second
		end
	end
end
const visible_width=480
const visible_height=480
const visible_size=32
# 不应使用特性改动
"将(lx,ly)左上角显示到画板(px,py)"
function draw(c::Chunk,lx::Int,ly::Int,px::Int,py::Int;envl::UInt8)
	rx=min(lx+15-px>>5,64)
	ry=min(ly+15-py>>5,64)
	for i in lx:rx
		for j in ly:ry
			tl=get_lig(c,i,j)
			if tl<envl
				tl=envl
			end
			x0=px+(i-lx)<<5
			y0=py+(j-ly)<<5
			if tl==0x0
				fill_rect(dcon,x0,y0,32,32;color=RGB(0,0,0))
				continue
			end
			b=c.blks[i,j]
			if hole(b) fill_rect(dcon,x0,y0,32,32;color=RGB(15/16,15/16,15/16))
			end
			b_show(b,dcon,x0,y0)
			if tl!=0x15
				fill_rect(dcon,x0,y0,32,32;color=RGBA(0,0,0,(15-tl)/16))
			end
		end
	end
end

mutable struct Dimension
	cs::Dict{Pair{Int,Int},Chunk}
end
"画板(0,0)显示坐标(x,y)"
function draw(d::Dimension,x::Float,y::Float)
#=
区块坐标
(x,y)------+---------+
  |    A   |    B    |
  +--(lx+64,ly+64)---+
  |    C   |    D    |
  +--------+---(x+15,y+15)
lx+64-x=64-tx
lx+64<x+15 <=> tx>49 <=> 额外区块需渲染
||显示的区块左上角坐标|取整后|不取整显示坐标/32|显示坐标/32|
|:-:|:-:|:-:|:-:|:-:|
|A|(tx,ty)|(tx1,ty1)|(0,0)|(tx1-tx,ty1-ty)|
|B|(tx,0)|(tx1,0)|(0,64-ty)|(tx1-tx,64-ty)|
|C|(0,ty)|(0,ty1)|(64-tx,0)|(64-tx,ty1-ty)|
|D|(0,0)|(0,0)|(64-tx,64-ty)|(64-tx,64-ty)|
=#
	envl=envlight()
	tx=mod(x,64)
	ty=mod(y,64)
	tx1=floor(Int,tx)
	ty1=floor(Int,ty)
	lx=floor(Int,x)>>5<<5
	ly=floor(Int,y)>>5<<5
	draw(d.cs[Pair(lx,ly)],tx1+1,ty1+1,floor((tx1-tx)*32),floor((ty1-ty)*32);envl=envl) # A
	if ty>49
		draw(d.cs[Pair(lx,ly+64)],tx1+1,1,floor((tx1-tx)*32),floor((64-ty)*32);envl=envl) # B
	end
	if tx>49
		lx+=64
		draw(d.cs[Pair(lx,ly)],1,ty1+1,floor((64-tx)*32),floor((ty1-ty)*32);envl=envl) # C
		if ty>49
			draw(d.cs[Pair(lx,ly+64)],1,1,floor((64-tx)*32),floor((64-ty)*32);envl=envl) # D
		end
	end
end

mutable struct Game
	ds::Dict{String,Dimension}
	ps::Vector{玩家}
	set::Dict{String,Any}
end
function Game()
	return Game(Dict{String,Dimension}(),Vector{玩家}(),Dict{String,Any}())
end
function pushsave(lx::Int,ly::Int,tx::Int,ty::Int,b::Block)
	p=Pair(lx,ly)
	if !haskey(sav,p)
		sav[p]=Dict{Int,Block}()
	end
	sav[p][tx>>6|ty]=b
end
function getlig(x::Int,y::Int)
	tx=x&63;ty=y&63
	lx=x>>6;ly=y>>6
	c=chk(dim,lx,ly)
	return get_lig(c,tx,ty)
end
function setlig(x::Int,y::Int,v::UInt8)
	tx=x&63;ty=y&63
	lx=x>>6;ly=y>>6
	c=chk(dim,lx,ly)
	set_lig(c,tx,ty,v)
end
function getblk(x::Int,y::Int)
	tx=x&63+1;ty=y&63+1
	lx=x>>6;ly=y>>6
	c=chk(dim,lx,ly)
	return c.blks[tx,ty]
end
function setblk(x::Int,y::Int,b::Block;player_put::Bool=false)
	tx=x&63+1;ty=y&63+1
	lx=x>>6;ly=y>>6
	c=chk(dim,lx,ly)
	e_exist(c.blks[tx,ty],x,y)
	c.blks[tx,ty]=b
	exist(b,x,y)
	if player_put
		e_put(b,x,y)
	end
	pushsave(lx,ly,tx,ty,b)
end
