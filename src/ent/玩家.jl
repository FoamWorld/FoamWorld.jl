mutable struct 玩家<:生物
	x::Float
	y::Float
	θ::Float
	health::Int
	its::IB
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
	ux=p.data[:ux];uy=p.data[:uy]
	if hypot(p.x-ux,p.y-uy)
		e_use(getblk(ux,uy))
		# if p===ply info_help(:event,:away_from_using_blk)
	end
end
steplength(::玩家)=0.3
wneed_updg(p::玩家)=p===ply
