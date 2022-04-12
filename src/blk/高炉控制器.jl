mutable struct 高炉控制器<:固体
	dire::UInt8
	working::Bool
	lx::Int
	ly::Int
	contain::Vector{Pair{Material,Int}}
end
function e_put(b::高炉控制器,x::Int,y::Int)
	b.dire=calc_facing(x,y)
end
function e_exist(b::高炉控制器,::Int,::Int)
	if !isempty(b.contain)
		for i in b.lx:b.lx+2
			for j in b.ly:b.ly+2
				setblk(i,j,岩浆())
			end
		end
	end
end
function use(b::高炉控制器,x::Int,y::Int)
	if !b.working
		wtrybuild(b,x,y)
		if !b.working
			info_help(:blk,:高炉控制器,:built;extra="($x,$y)")
		end
	end
end
function wtrybuild(b::高炉控制器,x::Int,y::Int)
	dir=b.dire+1
	cx=x-direx[dir]<<1 # 中心
	cy=y-direy[dir]<<1
	for i in cx-1:cx+1
		for j in cy-1:cy+1
			if !isa(getblk(i,j),空气)
				return false
			end
		end
	end
	b.lx=cx-1
	b.ly=cy-1
	for d in 1:4
		scx=cx+direx[d]<<1
		scy=cy+direy[d]<<1
		if d!=dir
			blk=getblk(scx,scy)
			if isa(blk,高炉壁)&&(blk.dire+1)==d
				blk.match=true
				blk.mx=x
				blk.my=y
			else
				return false
			end
		end
		le=dirl[dir]
		blk=getblk(scx+direx[le],scy+direy[le])
		if isa(blk,高炉壁)&&(blk.dire+1)==d
			blk.match=true
			blk.mx=x
			blk.my=y
		else
			return false
		end
		blk=getblk(scx-direx[le],scy-direy[le])
		if isa(blk,高炉壁)&&(blk.dire+1)==d
			blk.match=true
			blk.mx=x
			blk.my=y
		else
			return false
		end
	end
	b.working=true
	return true
end
