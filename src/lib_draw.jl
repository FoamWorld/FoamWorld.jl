function fill_rect(ctx::GraphicsContext,x::Int=0,y::Int=0,width::Int=32,height::Int=32)
	rectangle(ctx,x,y,width,height)
end
function fill_rect(ctx::GraphicsContext,x::Int=0,y::Int=0,width::Int=32,height::Int=32;color::RGB)
	set_source_rgb(ctx,red(color),green(color),blue(color))
	rectangle(ctx,x,y,width,height)
end
function fill_rect(ctx::GraphicsContext,x::Int=0,y::Int=0,width::Int=32,height::Int=32;color::RGBA)
	set_source_rgba(ctx,red(color),green(color),blue(color),alpha(color))
	rectangle(ctx,x,y,width,height)
end
function fill_text(ctx::GraphicsContext,x::Int=0,y::Int=0,text::String;color::RGB,size::Int)
	set_font_size(ctx,size)
	set_source_rgb(ctx,red(color),green(color),blue(color))
	move_to(ctx,x,y)
	show_text(ctx,text)
end
function fill_matrix(ctx::GraphicsContext,m::Matrix{ARGB32})
	sur=CairoImageSurface(m)
	set_source_surface(ctx,sur)
end
