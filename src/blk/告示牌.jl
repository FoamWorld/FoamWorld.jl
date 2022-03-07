mutable struct 告示牌<:固体
	str::String
	color::RGB
end
告示牌(str::String="",color::RGB=RGB(0x0,0x0,0x0))=告示牌(str,color)
c_use(::告示牌)=true
function use(b::告示牌,::Int,::Int)
	global curui=build_blk_gui()
	gr=GtkGrid()
	push!(curui,gr)
	gr[1,1]=GtkTextView(;editable=false,buffer=GtkTextBuffer(;text=langs[:blk][:告示牌][:s_str]))
	gr[1,2]=GtkTextView(;editable=false,buffer=GtkTextBuffer(;text=langs[:blk][:告示牌][:s_color]))
	gr[2,1]=GtkEntry()
	gr[2,2]=GtkColorButton()
	updg(b;grid=gr)
end
function updg(b::告示牌;grid::GtkGrid)
	set_gtk_property!(get_gtk_property(grid[2,1],:buffer,GtkEntryBuffer),:text,b.str)
	co=get_gtk_property(grid[2,2],:rgba,GdkRGBA)
	set_gtk_property!(co,:red,b.color.r)
	set_gtk_property!(co,:green,b.color.g)
	set_gtk_property!(co,:blue,b.color.b)
end
function e_use(b::告示牌)
	gr=curui[1]
	b.str=get_gtk_property(get_gtk_property(gr[2,1],:buffer,GtkEntryBuffer),:text,String)
	co=get_gtk_property(gr[2,2],:rgba,GdkRGBA)
	b.color.r=N0f8(get_gtk_property(co,:red,Cdouble))
	b.color.g=N0f8(get_gtk_property(co,:green,Cdouble))
	b.color.b=N0f8(get_gtk_property(co,:blue,Cdouble))
end
function b_show(b::告示牌,con,x::Int,y::Int)
	bid=id(b)
	so=get_loadedimg(bid)
	fill_image(con,so,x,y)
	push!(after_show,function() fill_text(con,b.str;color=b.color) end)
end
colbox(::告示牌,::Int,::Int)=EmptyCollisionBox()
hole(::告示牌)=true
transparent(::告示牌)=true
