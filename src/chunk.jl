mutable struct Chunk
	blks::SMatrix{64,64,Block,4096}
	ligs::SVector{UInt8,2048}
	tm::UInt
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
