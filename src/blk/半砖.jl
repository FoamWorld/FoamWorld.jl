mutable struct 半砖<:固体
	mat::Material
	dire::UInt8
end
id(b::半砖)="$(b.mat)半砖"
text(b::半砖)=langs[:name][typeof(b.mat).name.name]*langs[:name][:半砖]
hard(b::半砖)=hard(b.mat)
hole(::半砖)=true
function i_show(b::半砖,con)
	iid=id(b)
	if haskey(loadedimgs,iid)
		so=@inbounds loadedimgs[iid]
		fill_image(con,so,0,0,32,16)
	else
		fill_rect(con,0,0,32,16;color=theme(b.mat))
	end
end
function b_show(b::半砖,con,x::Int,y::Int)
	bid=id(b)
	if haskey(loadedimgs,bid)
		so=@inbounds loadedimgs[iid]
		if b.dire==0x0 fill_image(con,so,x,y,x+32,y+16)
		elseif b.dire==0x1 fill_image(con,so,x+16,y,x+32,y+32)
		elseif b.dire==0x2 fill_image(con,so,x,y+16,x+32,y+32)
		else fill_image(con,so,x,y,x+16,y+32)
		end
	else
		if b.dire==0x0 fill_rect(con,x,y,x+32,y+16;color=theme(b.mat))
		elseif b.dire==0x1 fill_rect(con,x+16,y,x+32,y+32;color=theme(b.mat))
		elseif b.dire==0x2 fill_rect(con,x,y+16,x+32,y+32;color=theme(b.mat))
		else fill_rect(con,x,y,x+16,y+32;color=theme(b.mat))
		end
	end
end
function colbox(b::半砖,x::Int,y::Int)
	if b.dire==0x0 return BCollisionBox{Float64}(x,y,x+1,y+0.5)
	elseif b.dire==0x1 return BCollisionBox{Float64}(x+0.5,y,x+1,y+1)
	elseif b.dire==0x2 return BCollisionBox{Float64}(x,y+0.5,x+1,y+1)
	else return BCollisionBox{Float64}(x,y,x+0.5,y+1)
	end
end
function e_put(b::半砖,x::Float64,y::Float64)
	x0=x-ply.x;y0=y-ply.y
	if x0>0
		if x0<y0 b.dire=0x2
		elseif x0<-y0 b.dire=0x0
		else b.dire=0x1
		end
	else
		if x0>y0 b.dire=0x0
		elseif x0>-y0 b.dire=0x2
		else b.dire=0x3
		end
	end
end
