struct 冰<:固体 end
i_show(::冰,con)=fill_rect(con,0,0;color=RGB(0xa0,0xc0,0xff))
b_show(::冰,con,x::Int,y::Int)=fill_rect(con,x,y;color=RGB(0xa0,0xc0,0xff))
upd(::冰,x::Int,y::Int)=for i in 1:4
	if light(getblk(x+direx[i],y+direy[i]))>0x8
		setblk(x,y,水())
	end
end
