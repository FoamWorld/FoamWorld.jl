mutable struct 原木<:固体
	t::UInt8
end
id(b::原木)="原木$(b.t)"
