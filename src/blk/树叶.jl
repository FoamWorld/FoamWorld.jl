mutable struct 树叶<:固体
	t::UInt8
end
id(b::树叶)="树叶$(b.t)"
