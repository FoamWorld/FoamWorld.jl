encode(obj::String)="\"$(esc_str2(obj))\""
encode(obj::Bool)=obj ? "T" : "F"
encode(obj::Missing)="mis"
encode(obj::Nothing)="n"
encode(obj::Number)=string(obj)
encode(obj::Symbol)="&\"$(escape_string(obj))\""
encode(obj::Char)="(Char,$(Int(obj)))"
encode(obj::RGB)="(RGB_N0f8,$(obj.r.i),$(obj.g.i),$(obj.b.i))"
RGB_N0f8(r::Int,g::Int,b::Int)=RGB{N0f8}(r,g,b)
function encode(obj::Vector)
	l=length(obj)
	if isempty(l)
		return "[]"
	end
	s="[$(encode(obj[1]))"
	for i in 2:l
		s*=",$(encode(obj[i]))"
	end
	return s*']'
end
function encode(obj::Dict)
	s="{"
	for i in obj
		s*="$(i.first):$(i.second),"
	end
	# s=s[1:end-1]
	return s*'}'
end
function encode(obj) # default
	ty=typeof(obj) # ty::DataType
	s="($(ty.name.name)" # ty.name::Core.TypeName
	li=fieldnames(ty)
	for i in li
		s*=",$(getfield(obj,i))"
	end
	return s*')'
end

function decode_get_elements(s::String)
	l=length(s);st=zero(UInt32);instr=false;a=[];last=1
	for i in 1:l
		c=s[i]
		if instr
			if c=='"'
				instr=false
			end
			continue
		end
		if c=='('||c=='['||c=='{'
			st+=1
		elseif c==')'||c==']'||c=='}'
			st-=1
		elseif c=='"'
			instr=true
		elseif c==','
			if st==0
				push!(a,decode(s[last:i-1]))
				last=i+1
			end
		end
	end
	if last!=l+1
		push!(a,decode(s[last:l]))
	end
	return a
end
function decode_get_pairs(s::String)
	l=length(s);st=zero(UInt32);instr=false;a=Dict();last=1;tkey=nothing
	for i in 1:l
		c=s[i]
		if instr
			if c=='"'
				instr=false
			end
			continue
		end
		if c=='('||c=='['||c=='{'
			st+=1
		elseif c==')'||c==']'||c=='}'
			st-=1
		elseif c=='"'
			instr=true
		elseif c==':'
			if st==0
				tkey=decode(s[last:i-1])
				last=i+1
			end
		elseif c==','
			if st==0
				a[tkey]=decode(s[last:i-1])
				last=i+1
			end
		end
	end
	if last!=l+1
		a[tkey]=decode(s[last:l])
	end
	return a
end
function decode_get_parts(s::String)
	l=length(s);st=zero(UInt32);instr=false;a=Vector{String}();last=1
	for i in 1:l
		c=s[i]
		if instr
			if c=='"'
				instr=false
			end
			continue
		end
		if c=='('||c=='['||c=='{'
			st+=1
		elseif c==')'||c==']'||c=='}'
			st-=1
		elseif c=='"'
			instr=true
		elseif c==','
			if st==0
				push!(a,s[last:i-1])
				last=i+1
			end
		end
	end
	if last!=l+1
		push!(a,s[last:l])
	end
	return a
end
function decode(s::String)
	if s=="T"
		return true
	elseif s=="F"
		return false
	elseif s=="mis"
		return missing
	elseif s=="n"
		return nothing
	elseif s=="Inf"
		return Inf
	elseif s=="-Inf"
		return -Inf
	elseif s=="NaN"
		return NaN
	end
	s=clean_str(s)
	c=s[1]
	if c=='"' return unesc_str2(s[2:end-1])
	elseif c=='&'
		if s[2]=='"' return Symbol(unesc_str2(s[3:end-1])) end
		return Symbol(s[2:end])
	elseif c=='['
		return decode_get_elements(s[2:end-1])
	elseif c=='{'
		return decode_get_pairs(s[2:end-1])
	elseif c=='('
		a=decode_get_parts(s[2:end-1])
		name=popfirst!(a)
		l=length(a)
		b=Vector{Any}(undef,l)
		for i in 1:l
			b[i]=decode(a[i])
		end
		f=eval(Symbol(name))
		return f(b...)
	elseif '0'<=c<='9'
		fl=true
		for i in 1:length(s)
			c=s[i]
			if c<'0'||c>'9'
				fl=false
				break
			end
		end
		if fl
			return parse(Int,s)
		else
			return parse(Float64,s)
		end
	end
end

function read_code(io::IO)
	s=""
	for i in eachline(io)
		s*=i
	end
	return decode(s)
end
function write_code(io::IO,obj)
	println(io,encode(obj))
end
function read_code(p::String)
	io=open(p,"r")
	s=""
	for i in eachline(io)
		s*=i
	end
	close(io)
	return decode(s)
end
function write_code(p::String)
	io=open(p,"w")
	println(io,encode(obj))
	close(io)
end
