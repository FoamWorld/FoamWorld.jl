abstract type Item end
id(i::Item)=String(typeof(i).name.name)
text(i::Item)=langs[:name][typeof(i).name.name]
stack(::Item)=0x10 # 16
c_use(::Item)=false
1_use(::Item)=true
t_blk(::Item)=missing
function i_show(i::Item,con=dcon)
	clear_rect(con,0,0;color=RGB_(0x70,0x80,0x90))
	i_show_l(i,con)
end
function i_show_l(i::Item,con)
	iid=id(i)
	so=get_loadedimg(iid)
	fill_image(con,so,0,0)
end

struct EI<:Item end
id(i::EI)=""
text(i::EI)=""
i_show_l(::EI,::Any)=nothing

mutable struct IFB<:Item
	wr::Block
end
id(i::IFB)=id(i.wr)
text(i::IFB)=text(i.wr)
stack(i::IFB)=stack(i.wr)
t_blk(i::IFB)=deepcopy(i.wr)
i_show(i::IFB,con=dcon)=i_show(i.wr,con)

include("书.jl")
include("桶.jl")
abstract type 零件<:Item end
