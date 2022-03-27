struct 无限迷宫<:地形生成器 end
function exist(::无限迷宫)
	ply.x=1.5
	ply.y=1.5
end
init(::无限迷宫)=nothing
function infmaze_4(c::Chunk,lx::Int,ly::Int,rx::Int,ry::Int)
	if lx==rx&&ly==ry
		for i in lx:rx
			for j in ly:ry
				c.blks[i,j]=空气()
			end
		end
		return
	end
	# 递归分割
	mx=crandom_even(lx+1,rx-1)
	my=crandom_even(ly+1,ry-1)
	for i in lx:rx
		c.blks[i,my]=星岩()
	end
	for j in ly:ry
		c.blks[mx,j]=星岩()
	end
	infmaze_4(c,lx,ly,mx-1,my-1)
	infmaze_4(c,mx+1,ly,rx,my-1)
	infmaze_4(c,lx,my+1,mx-1,ry)
	infmaze_4(c,mx+1,my+1,rx,ry)
	dir=crand()&0x3
	if dir==0x0
		c.blks[mx,crandom_even(my+1,ry)]=空气()
		c.blks[crandom_even(lx,mx-1),my]=空气()
		c.blks[crandom_even(mx+1,rx),my]=空气()
	elseif dir==0x1
		c.blks[mx,crandom_even(ly,my-1)]=空气()
		c.blks[crandom_even(lx,mx-1),my]=空气()
		c.blks[crandom_even(mx+1,rx),my]=空气()
	elseif dir==0x2
		c.blks[mx,crandom_even(ly,my-1)]=空气()
		c.blks[mx,crandom_even(my+1,ry)]=空气()
		c.blks[crandom_even(mx+1,rx),my]=空气()
	else
		c.blks[mx,crandom_even(ly,my-1)]=空气()
		c.blks[mx,crandom_even(my+1,ry)]=空气()
		c.blks[crandom_even(lx,mx-1),my]=空气()
	end
end
function use(::无限迷宫,c::Chunk,x::Int,y::Int)
	for i in 1:64
		c.blks[i,1]=星岩()
		c.blks[1,i]=星岩()
	end
	srand(xor(x<<15+y,lsetting["seed"]))
	infmaze4(c,2,2,64,64)
	c.blks[1,(crand()&31)<<1]=空气() # 区块间通道
	c.blks[(crand()&31)<<1,1]=空气()
end
