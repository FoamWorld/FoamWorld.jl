abstract type CollisionBox2 end
struct EmptyCollisionBox<:CollisionBox2 end
collide(::CollisionBox2,::EmptyCollisionBox)=false
struct BCollisionBox{T}<:CollisionBox2 where T<:Number # 横平竖直的矩形
	lx::T
	ly::T
	rx::T
	ry::T
end
struct SegCollisionBox{T}<:CollisionBox2 where T<:Number # 线段,保证lx<=rx
	lx::T
	ly::T
	rx::T
	ry::T
end
struct CirCollisionBox{T}<:CollisionBox2 where T<:Number # 圆
	x::T
	y::T
	r::T
end
function collide(s::SegCollisionBox,b::BCollisionBox)
	lxin=(b.lx<s.lx<b.rx)
	rxin=(b.lx<s.rx<b.rx)
	lyin=(b.ly<s.ly<b.ry)
	ryin=(b.ly<s.ry<b.ry)
	if  lxin&&rxin&&lyin&&ryin # 线段在矩形内
		return true
	end
	if s.ly==s.ry # 线段水平
		if lyin && (lxin||rxin)
			return true
		end
		return false
	end
	if s.lx==s.rx # 线段竖直
		if lxin && (lyin||ryin)
			return true
		end
		return false
	end
	# s: y=ax+k
	a=(s.ry-s.ly)/(s.rx-s.lx)
	k=(s.rx*s.ly-s.lx*s.ry)/(s.rx-s.lx)
	if (s.lx<b.lx<s.rx&&b.ly<a*b.lx+k<b.ry) || # 交x=b.lx
		(s.lx<b.rx<s.rx&&b.ly<a*b.rx+k<b.ry) # 交x=b.rx
		return true
	end
	if s.ly<s.ry
		sl=s.ly
		sr=s.ry
	else
		sl=s.ry
		sr=s.ly
	end
	if (sl<b.ly<sr&&b.lx<(b.ly-k)/a<b.rx) || # 交y=b.ly
		(sl<b.ry<sr&&b.lx<(b.ry-k)/a<b.rx) # 交y=b.ry
		return true
	end
	return false
end
function collide_with(ci::CirCollisionBox,a::Number,b::Number,c::Number) # ax+by+c=0
	return abs(a*ci.x+b*ci.y+c)<hypot(a,b)*ci.r
end
function collide(c::CirCollisionBox,b::BCollisionBox)
	# 圆角矩形，分成2个矩形4个圆
	return (b.lx<c.x<b.ly&&b.ly-c.r<c.y<b.ry+c.r) ||
	(b.ly<c.y<b.ry&&b.lx-c.r<c.x<b.rx+c.r) ||
	(hypot(c.x-b.lx,c.y-b.ly)<c.r) ||
	(hypot(c.x-b.lx,c.y-b.ry)<c.r) ||
	(hypot(c.x-b.rx,c.y-b.ly)<c.r) ||
	(hypot(c.x-b.rx,c.y-b.ry)<c.r)
end
function collide(c::CirCollisionBox,bs::Dimension)
	lx=floor(c.x-c.r);rx=floor(c.x+c.r)
	ly=floor(c.y-c.r);ry=floor(c.y+c.r)
	for i in lx:ly
		for j in rx:ry
			if collide(c,colbox(blk(bs,i,j),i,j))
				return true
			end
		end
	end
	return false
end
function collide_move(c::CirCollisionBox,bs::Dimension,vx::Number,vy::Number,max_depth::UInt8=0x8)
	lx=0;ly=0
	rx=vx;ry=vy
	anx=0;any=0
	while true # 二分，原则：保证不碰撞
		mx=(lx+rx)/2
		my=(ly+ry)/2
		t=CirCollisionBox(c.x+mx,c.y+my,c.r)
		if collide(t,bs)
			if max_depth==0x0
				return Pair(anx,any)
			end
			rx=mx
			ry=my
		else
			if max_depth==0x0
				return Pair(mx,my)
			end
			anx=lx=mx
			any=ly=my
		end
		max_depth-=0x1
	end
end
