mutable struct Befunge<:固体
	dire::UInt8
	coll::Bool
	error::Bool # 是否出现过错误
	stack::Vector{Int}
	on::Union{Nothing,地毯}
	ext::Dict{Symbol,String}
end
Befunge(dire::UInt8=0x1)=Befunge(dire,false,false,[-1],nothing,Dict{Symbol,Any}(:message=>"hello, world"))
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
	if tx=='^' b.dire=0x1
	elseif tx=='>' b.dire=0x2
	elseif tx=='v' b.dire=0x3
	elseif tx=='<' b.dire=0x4
	elseif tx=='?' b.dire=crandom(1,4)
	elseif tx=='_'
		if isempty(bs) b.error=true;return end
		p=pop!(bs)
		if p==0 b.dire=0x2
		else b.dire=0x4 end
	elseif tx=='|'
		if isempty(bs) b.error=true;return end
		p=pop!(bs)
		if p==0 b.dire=0x3
		else b.dire=0x1 end
	elseif tx=='+'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(bs)
		push!(bs,fi+se)
	elseif tx=='-'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(bs)
		push!(bs,se-fi)
	elseif tx=='*'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(s)
		push!(bs,fi*se)
	elseif tx=='/'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(bs)
		push!(bs,div(se,fi))
	elseif tx=='%'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(bs)
		push!(bs,mod(se,fi))
	elseif tx=='!'
		if isempty(bs) b.error=true;return end
		p=pop!(bs)
		push!(bs,p==0 ? 0 : 1)
	elseif tx=='`'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(bs)
		push!(bs,se>fi ? 1 : 0)
	elseif '0'<=tx<='9'
		push!(bs,tx-'0')
	elseif tx==':'
		if isempty(bs) b.error=true;return end
		push!(bs,last(bs))
	elseif tx=='\\'
		if length(bs)<2 b.error=true;return end
		fi=pop!(bs)
		se=pop!(bs)
		push!(bs.fi)
		push!(bs,se)
	elseif tx=='$'
		if isempty(bs) b.error=true;return end
		pop!(bs)
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
