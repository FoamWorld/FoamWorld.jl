mutable struct 玩家<:生物
	x::Float
	y::Float
	θ::Float
	health::Int
	its::IB
	chosen::Int
	floorx::Int
	floory::Int
	data::Dict{Symbol,Any}
end
give!(p::玩家,i::Item,n::Int)=give!(p.its,i,n)
colbox(::玩家,x::Float,y::Float)=CirCollisionBox{Float}(x,y,0.4375)
function updg(p::玩家)
	if !wneed_updg(p)
		return
	end
end
function move!(p::玩家,x::Float,y::Float)
	col=colbox(p,x,y)
	v::Pair=collide_move(col,dim,x,y)
	p.x+=v.first
	p.y+=v.second
	p.floorx=floor(p.x)
	p.floory=floor(p.y)
	ux=p.data[:ux];uy=p.data[:uy]
	if hypot(p.x-ux,p.y-uy)
		e_use(getblk(ux,uy))
		# if p===ply info_help(:event,:away_from_using_blk)
	end
end
steplength(::玩家)=0.3
strength(::玩家)=15
wneed_updg(p::玩家)=p===ply
function c_reach(p::玩家,x::Int,y::Int)
	if lsetting[:reach_all] return true end
	if hypot(p.x-x,p.y-y)>4
		info_help(:game,:too_far)
		return false
	end
	seg=x+0.5<p.x ? SegCollisionBox(x+0.5,y+0.5,p.x,p.y) : SegCollisionBox(p.x,p.y,x+0.5,y+0.5)
	lx,rx=p.floorx<x ? (p.floorx,x) : (x,p.floorx)
	ly,ry=p.floory<y ? (p.floory,y) : (y,p.floory)
	for i in lx:rx
		for j in ly:ry
			col=colbox(getblk(i,j))
			if collide(seg,col) return false end
		end
	end
	return true
end
