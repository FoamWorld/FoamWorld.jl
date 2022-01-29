abstract type Item end
id(i::Item)=String(typeof(i))
stack(i::Item)=0x10 # 16
c_use(i::Item)=false
t_blk(::Item)=missing

struct EI<:Item end
id(i::EI)=""

mutable struct IFB<:Item
	wr::Block
end
id(i::IFB)=id(i.wr)
stack(i::IFB)=stack(i.wr)
t_blk(i::IFB)=deepcopy(i.wr)

abstract type 零件<:Item end
