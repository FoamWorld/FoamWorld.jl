abstract type CollisionBox2 end
struct EmptyCollisionBox<:CollisionBox2 end
collide(::CollisionBox2,::EmptyCollisionBox)=false
struct BCollisionBox{T}<:CollisionBox2 where T<:Number # 横平竖直的矩形
	lx::T
	ly::T
	rx::T
	ry::T
end
struct SegCollisionBox{T}<:CollisionBox2 where T<:Number # 线段
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
