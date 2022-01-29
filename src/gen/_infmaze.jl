function infmaze_4(c::Chunk,lx::Int,ly::Int,rx::Int,ry::Int)
	if lx==rx&&ly==ry
		for i in lx:rx
			for j in ly:ry
				c.bs[i,j]=空气()
			end
		end
		return
	end
	# 递归分割
	mx=crandom_even(lx+1,rx-1)
	my=crandom_even(ly+1,ry-1)
	for i in lx:rx
		c.bs[i,my]=星岩()
	end
	for j in ly:ry
		c.bs[mx,j]=星岩()
	end
	infmaze_4(c,lx,ly,mx-1,my-1)
	infmaze_4(c,mx+1,ly,rx,my-1)
	infmaze_4(c,lx,my+1,mx-1,ry)
	infmaze_4(c,mx+1,my+1,rx,ry)
	dir=crand()&0x3
	if dir==0x0
		c.bs[mx,crandom_even(my+1,ry)]=空气()
		c.bs[crandom_even(lx,mx-1),my]=空气()
		c.bs[crandom_even(mx+1,rx),my]=空气()
	elseif dir==0x1
		c.bs[mx,crandom_even(ly,my-1)]=空气()
		c.bs[crandom_even(lx,mx-1),my]=空气()
		c.bs[crandom_even(mx+1,rx),my]=空气()
	elseif dir==0x2
		c.bs[mx,crandom_even(ly,my-1)]=空气()
		c.bs[mx,crandom_even(my+1,ry)]=空气()
		c.bs[crandom_even(mx+1,rx),my]=空气()
	else
		c.bs[mx,crandom_even(ly,my-1)]=空气()
		c.bs[mx,crandom_even(my+1,ry)]=空气()
		c.bs[crandom_even(lx,mx-1),my]=空气()
	end
end
function gen__infmaze_chunk(c::Chunk,x::Int,y::Int)
	for i in 1:64
		c.bs[i,1]=星岩()
		c.bs[1,i]=星岩()
	end
	srand(xor(x<<15+y,lsetting["seed"]))
	infmaze4(c,2,2,64,64)
	c.bs[1,(crand()&31)<<1]=空气() # 区块间通道
	c.bs[(crand()&31)<<1,1]=空气()
end
function gen__infmaze_f()
	ply.x=1.5
	ply.y=1.5
end
function gen__infmaze_init()
end
const _infmaze=MapGenerator(gen__infmaze_f,gen__infmaze_init,gen__infmaze_chunk)
