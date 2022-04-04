struct 高炉壁<:固体
	dire::UInt8
	match::Bool
	mx::Int
	my::Int
end
高炉壁()=高炉壁(0x0,false,0,0)
function e_put(b::高炉壁,x::Int,y::Int)
	b.dire=calc_facing(x,y)
end
# exist(b::高炉壁,x::Int,y::Int)
function e_exist(b::高炉壁,::Int,::Int)
	if !b.match
		return
	end
	c=getblk(b.mx,b.my)
	if isa(c,高炉管理器)&&c.working
		c.working=false
		if isempty(c.contain)
			return
		end
		for i in c.lx:c.lx+2
			for j in c.ly:c.ly+2
				setblk(i,j,岩浆())
			end
		end
		empty!(c.contain)
	end
end
