mutable struct 岩浆<:液体
	depth::UInt8
end
岩浆()=岩浆(0x3)
b_show(b::岩浆,con,x::Int,y::Int)=fill_rect(con,x,y;color=RGB(0xff,0xff,[0xa0,0xf0,0xfe,0xff][b.depth+1]))
function upd(b::岩浆,x::Int,y::Int)
	if lsetting[:t]&0x3!=0x0 return end
	if b.depth==0x0
		fl=true
		for i in 1:4
			tb=getblk(x+direx[i],y+direy[i])
			if isa(tb,岩浆)&&tb.depth>0x0
				fl=false
				break
			elseif isa(tb,水)
				setblk(x,y,安山岩())
				return
			end
		end
		if fl setblk(x,y,空气()) end
		return
	end
	co=0x0
	ldep=b.depth-0x1
	meetw=false;meetr=false;meeti=false
	for i in 1:4
		tb=getblk(x+direx[i],y+direy[i])
		if isa(tb,岩浆)
			if tb.depth<ldep # 填补
				tb.depth=ldep
			elseif tb.depth>co
				co=tb.depth
			end
		elseif isa(tb,空气) # 扩散
			setblk(x+direx[i],y+direy[i],岩浆(ldep))
		elseif isa(tb,水)
			meetw=true
		elseif isa(tb,岩石)
			meetr=true
		elseif isa(tb,冰) # 迅速冷却
			meeti=true
		end
	end
	if meeti
		setblk(x,y,黑曜岩())
		return
	end
	if meetw
		setblk(x,y,meer ? 花岗岩() : 玄武岩())
		return
	end
	if co<=b.depth&&b.depth!=0x3 setblk(x,y,空气()) end # 消散
end
