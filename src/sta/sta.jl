abstract type 状态 end
id(s::状态)=String(typeof(s).name.name)
exist(::状态)=nothing
e_exist(::状态)=nothing
c_union(::状态)=true
function Base.union(s1::T,::T,t1::UInt,t2::UInt)where T<:状态
	return Pair(max(t1,t2),s1)
end

struct 状态组
	data::Dict{String,Union{Pair{UInt,状态},Vector{Pair{UInt,状态}}}}
end
function Base.push!(ss::状态组,t::UInt,s::状态)
	sid=id(s)
	if haskey(ss.data,sid)
		if c_union(s)
			@inbounds pa=ss.data[sid]
			@inbounds ss.data[sid]=union(pa.second,s,pa.first,t)
		else
			push!(ss.data[sid]::Vector{Pair},Pair(t,s))
		end
	else
		if c_union(s)
			ss.data[sid]=Pair(t,s)
		else
			ss.data[sid]=[Pair(t,s)]
		end
	end
end

struct 自发移动
	x::Float
	y::Float
end
upd(t::Entity,s::自发移动)=move(t,s.x,s.y)
c_union(::自发移动)=false

abstract type 中毒<:状态 end
