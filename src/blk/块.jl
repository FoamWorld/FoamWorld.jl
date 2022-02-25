mutable struct 块<:固体
	mat::Material
end
id(b::块)="$(b.mat)块"
text(b::块)=langs[:name][typeof(b.mat).name.name]*langs[:name][:块]
hard(b::块)=hard(b.mat)
function i_show(b::块,con)
	iid=id(b)
	if haskey(loadedimgs,iid)
		so=@inbounds loadedimgs[iid]
		fill_image(con,so,0,0)
	else
		fill_rect(con,0,0;color=theme(b.mat))
	end
end
function b_show(b::块,con,x::Int,y::Int)
	bid=id(b)
	if haskey(loadedimgs,bid)
		so=@inbounds loadedimgs[iid]
		fill_image(con,so,x,y)
	else
		fill_rect(con,x,y;color=theme(b.mat))
	end
end
