abstract type Item end
id(i::Item)=String(typeof(i).name.name)
text(i::Item)=langs[:name][typeof(i).name.name]
stack(::Item)=0x10 # 16
c_use(::Item)=false
one_use(::Item)=true
t_blk(::Item)=missing
function i_show(i::Item,con=dcon)
	clear_rect(con,0,0;color=RGB_(0x70,0x80,0x90))
	i_show_l(i,con::DrawContext)
end
function i_show_l(i::Item,con::DrawContext)
	iid=id(i)
	so=get_loadedimg(iid)
	fill_image(con,so,0,0)
end

struct EI<:Item end
id(i::EI)=""
text(i::EI)=""
i_show_l(::EI,::Any)=nothing

macro iwrap(ty,sy::Symbol)
	return :($sy(i::$ty)=$sy(i.wr))
end
macro iwraps(ty,sys::Symbol...)
	for sy in sys
		eval(:($sy(i::$ty)=$sy(i.wr)))
	end
end

mutable struct IFB<:Item
	wr::Block
end
@iwraps IFB id text stack
t_blk(i::IFB)=deepcopy(i.wr)
i_show(i::IFB,con=dcon)=i_show(i.wr,con::DrawContext)

mutable struct NI<:Item
	wr::Item
	name::String
end
id(::NI)="NI"
text(i::NI)=i.name
stack(::NI)=0x1
@iwraps NI c_use one_use use e_use updg t_blk
i_show(i::NI,con::DrawContext)=i_show(i.wr,con::DrawContext)

mutable struct DI<:Item
	wr::Item
	detail::Dict{Symbol,Any}
end
id(::DI)="DI"
text(i::DI)=haskey(i.detail,:name) ? i.detail[:name] : text(i.wr)
stack(::DI)=0x1
@iwraps DI c_use one_use use e_use updg t_blk
i_show(i::DI,con::DrawContext)=i_show(i.wr,con::DrawContext)

include("模具.jl")
include("书.jl")
include("桶.jl")
abstract type 零件<:Item end
id(i::零件)="$(i.mat)$(typeof(i).name.name)"
text(i::零件)=langs[:name][typeof(i.mat).name.name]*langs[:name][typeof(i).name.name]
include("薄板.jl")
mutable struct 锭<:零件 mat::Material end
mutable struct 棍<:零件 mat::Material end
