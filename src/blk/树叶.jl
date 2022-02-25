mutable struct 树叶<:固体
	t::UInt8
end
id(b::树叶)="树叶$(b.t)"
text(b::树叶)=langs[:木name][b.t]*langs[:name][:树叶]
