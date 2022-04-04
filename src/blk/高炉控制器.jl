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
end
