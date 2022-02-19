mutable struct 木板<:固体
	t::UInt8
end
id(b::木板)="木板$(b.t)"
