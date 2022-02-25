mutable struct 树苗<:固体
	t::UInt8
end
text(b::树苗)=langs[:木name][b.t]*langs[:name][:树苗]
function upd(b::树苗,x::Int,y::Int)
	r=crand()
	if r>>3!=0
		if b.t==0x0 wgrow0(x,y,r) end
	end
end
colbox(::树苗,::Int,::Int)=EmptyCollisionBox()
hole(::树苗)=true
transparent(::树苗)=true
function wgrow0(x::Int,y::Int,r::UInt32) # 苍穹木
	if r<4
		wgrow0_ray(x,y,1,8)
		wgrow0_ray(x,y,3,8)
	else
		wgrow0_ray(x,y,2,8)
		wgrow0_ray(x,y,4,8)
	end
	setblk(x,y,原木(0x0))
end
function wgrow0_ray(x::Int,y::Int,dire::Int,len::UInt)
	l=crandom(1,len)
	for i in 1:l # 逐渐生长
		x0=x+direx[dire]*i;y0=y+direy[dire]*i
		if isa(getblk(x0,y0),空气) # 推断可生长
			setblk(x0,y0,原木(0x0))
		else
			l=i-1
			break
		end
	end
	if l>=2 # 生枝
		r=crand()
		x0=x+direx[dire]*(l-1)
		y0=y+direy[dire]*(l-1)
		dl=dirl[l]
		dr=dirr[l]
		if r&1==0 # 左枝
			wgrow0_ray(x0,y0,dl,l>>1)
			if r&7<4
				x1=x+direx[dire]*l+direx[dl]
				y1=y+direy[dire]*l+direy[dl]
				if isa(getblk(x1,y1),空气) setblk(x1,y1,树叶(0x0)) end
			end
		end
		if r&3<2 # 右枝
			wgrow0_ray(x0,y0,dr,l>>1)
			if r&15<8
				x1=x+direx[dire]*l+direx[dr]
				y1=y+direy[dire]*l+direy[dr]
				if isa(getblk(x1,y1),空气) setblk(x1,y1,树叶(0x0)) end
			end
		end
	end
end
