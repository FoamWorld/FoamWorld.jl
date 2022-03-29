mutable struct 地毯<:固体
	text::Char
	color::RGB
	background_color::RGB
end
ws6(c::UInt8)=c<10 ? c+'0' : '7'+c # 'A'-10
wsrgb(x::RGB)=ws6(x.r>>4)*ws6(x.r&15)*ws6(x.g>>4)*ws6(x.g&15)*ws6(x.b>>4)*ws6(x.b&15)
id(b::地毯)="$(wsrgb(b.background_color))底$(wrgb(b.color))色$(Int(b.text))地毯"
function i_show(i::地毯,con::DrawContext)
	fill_rect(con,0,0;color=i.background_color)
	fill_text(con,i.text,4,4;color=i.color,size=24)
end
function b_show(b::地毯,con,x::Int,y::Int)
	fill_rect(con,x,y;color=b.background_color)
	fill_text(con,i.text,x+4,y+4;color=b.color,size=24)
end
colbox(::地毯,::Int,::Int)=EmptyCollisionBox()
transparent(::地毯)=true
wtext(b::地毯)=b.text
