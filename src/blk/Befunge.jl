mutable struct Befunge<:固体
	dire::UInt8
	coll::Bool
	error::Bool
	stack::Vector{Int}
	on::Union{Nothing,地毯}
	input::IO
	output::String
end
Befunge(dire::UInt8=0x1)=Befunge(dire,false,false,[-1],nothing,stdin,"")
function i_show(::Befunge,con::DrawContext)
	clear_rect(con,0,0;color=:slategray)
	so=get_loadedimg("Befunge0")
	fill_image(con,so,2,2,28,28)
end
function b_show(b::Befunge,con,x::Int,y::Int)
	if b.error
		so=get_loadedimg("Befunge1")
	else
		so::Matrix=get_loadedimg("Befunge0")
		if so.dire==0x2
			so=rotr90(so)
		elseif so.dire==0x3
			so=rot180(so)
		elseif so.dire==0x4
			so=rotr90(so)
		end
	end
	if b.on===nothing
		fill_image(con,so,x,y)
	else
		clear_rect(con,x,y;color=b.on.background_color)
		fill_image(con,so,x+2,y+2,28,28)
	end
end
function upd(b::Befunge,x::Int,y::Int)
	if b.on===nothing
		b.error=true
		return
	end
	tx=wtext(b.on::地毯)
	bs=b.stack
	if b.coll
		if tx=='"' b.coll=false
		else push!(bs,tx) end
		wmove(b,x,y)
		return
	end
	try
		tx=='+' ? begin fi=pop!(bs);se=pop!(bs);push!(bs,fi+se) end :
		tx=='-' ? begin fi=pop!(bs);se=pop!(bs);push!(bs,se-fi) end :
		tx=='*' ? begin fi=pop!(bs);se=pop!(bs);push!(bs,fi*se) end :
		tx=='/' ? begin fi=pop!(bs);se=pop!(bs);push!(bs,div(se,fi,RoundDown)) end :
		tx=='%' ? begin fi=pop!(bs);se=pop!(bs);push!(bs,mod(se,fi)) end :
		tx=='!' ? begin p=pop!(bs);push!(bs,p==0 ? 0 : 1) end :
		tx=='`' ? begin fi=pop!(bs);se=pop!(bs);push!(bs,se>fi ? 1 : 0) end :
		tx=='>' ? begin b.dire=0x2 end :
		tx=='<' ? begin b.dire=0x4 end :
		tx=='^' ? begin b.dire=0x1 end :
		tx=='v' ? begin b.dire=0x3 end :
		tx=='?' ? begin b.dire=crandom(1,4) end :
		tx=='_' ? begin p=pop!(bs);b.dire=p==0 ? 0x2 : 0x4 end :
		tx=='|' ? begin p=pop!(bs);b.dire=p==0 ? 0x3 : 0x1 end :
		# "
		tx==':' ? begin push!(bs,last(bs)) end :
		tx=='\\' ? begin fi=pop!(bs);se=pop!(bs);push!(bs.fi);push!(bs,se) end :
		tx=='$' ? begin pop!(bs) end :
		tx=='.' ? begin b.output*=string(pop!(bs)) end :
		tx==',' ? begin b.output*=Char(pop!(bs)) end :
		tx=='#' ? begin wmove(b,x,y);x+=direx[b.dire];y+=direy[b.dire] end :
		tx=='g' ? begin
			y=pop!(bs);x=pop!(bs)
			blk=getblk(x,y)
			if isa(blk,地毯) push!(bs,wtext(blk))
			else throw(true)
			end
		end :
		tx=='p' ? begin
			y=pop!(bs);x=pop!(bs);v=pop!(bs)
			blk=getblk(x,y)
			if isa(blk,地毯) blk.text=Char(v)
			else throw(true)
			end
		end :
		tx=='&' ? begin int=parse(Int,readline(b.input));push!(bs,int) end :
		tx=='~' ? begin char=read(b.input,Char);push!(bs,Int(char)) end :
		tx=='@' ? begin return end :
		'0'<=tx<='9' ? begin push!(bs,tx-'0') end : nothing
	catch
		b.error=true
		return
	end
	wmove(b,x,y)
end
function wmove(b::Befunge,x::Int,y::Int)
	x0=x+direx[b.dire]
	y0=y+direy[b.dire]
	tar=getblk(x0,y0)
	if isa(tar,地毯)
		setblk(x,y,b.on)
		b.on=tar
		setblk(x0,y0,b)
	else
		b.error=true
	end
end
