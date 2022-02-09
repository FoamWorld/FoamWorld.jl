abstract type Item end
id(i::Item)=String(typeof(i).name.name)
stack(::Item)=0xf # 15
c_use(::Item)=false
1_use(::Item)=true
t_blk(::Item)=missing
function i_show(i::Item,con=dcon;theme=:slategray)
	clear_rect(con,0,0;color=theme)
	i_show_l(i,con)
end
function i_show_l(i::Item,con)
	iid=id(i)
	if haskey(loadedimgs,iid)
		so=@inbounds loadedimgs[iid]
	else
		so=loadedimgs["notexture"]
	end
	fill_image(con,so,0,0)
end

struct EI<:Item end
id(i::EI)=""
i_show_l(::EI,::Any)=nothing

mutable struct IFB<:Item
	wr::Block
end
id(i::IFB)=id(i.wr)
stack(i::IFB)=stack(i.wr)
t_blk(i::IFB)=deepcopy(i.wr)
i_show(i::IFB,con=dcon)=i_show(i.wr,con)

include("书.jl")
include("桶.jl")
abstract type 零件<:Item end
