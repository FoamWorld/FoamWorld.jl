mutable struct 水<:液体
	depth::UInt8
end
水()=水(0x3)
b_show(b::水,con,x::Int,y::Int)=fill_rect(con,x,y;color=RGB(0x40-b.depth<<4,0x50-b.depth<<4,0xf0-b.depth<<4))
function upd(b::水,x::Int,y::Int)
	if lsetting[:t]&0x3!=0x0 return end
	if b.depth==0x0
		fl=true
		for i in 1:4
			tb=getblk(x+direx[i],y+direy[i])
			if isa(tb,水)&&tb.depth>0x0
				fl=false
				break
			end
		end
		if fl setblk(x,y,空气()) end
		return
	end
	co=0x0
	ldep=b.depth-0x1
	for i in 1:4
		tb=getblk(x+direx[i],y+direy[i])
		if isa(tb,水)
			if tb.depth<ldep # 填补
				tb.depth=ldep
			elseif tb.depth>co
				co=tb.depth
			end
		elseif isa(tb,空气) # 扩散
			setblk(x+direx[i],y+direy[i],水(ldep))
		end
	end
	if co<=b.depth&&b.depth!=0x3 setblk(x,y,空气()) end # 消散
end
