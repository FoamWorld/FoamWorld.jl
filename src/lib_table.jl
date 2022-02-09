mutable struct Table{A,B} # A!=B
	f::Dict{A,B}
	inv::Dict{B,A}
end
function Table{A,B}()where {A,B}
	return Table{A,B}(Dict{A,B}(),Dict{B,A}())
end
function insert!(t::Table{A,B},a::A,b::B)where {A,B}
	t.f[a]=b
	t.inv[b]=a
end
function Base.haskey(t::Table{A,B},a::A)where {A,B}
	return haskey(t.f,a)
end
function Base.haskey(t::Table{A,B},b::B)where {A,B}
	return haskey(t.inv,b)
end
function Base.getindex(t::Table{A,B},a::A)where {A,B}
	return t.f[a]
end
function Base.getindex(t::Table{A,B},b::B)where {A,B}
	return t.inv[b]
end
