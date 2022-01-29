encode(obj::String)="\"$(en_str(obj))\""
encode(obj::Bool)=obj ? "T" : "F"
encode(obj::Missing)="mis"
encode(obj::Nothing)="n"
encode(obj::Number)=string(obj)
function encode(obj::Vector)
	l=length(obj)
	if l==0
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
	elseif s=="NaN"
		return NaN
	end
	c=s[1]
	if c=='"'
		a=s[2:end-1]
		return de_str(a)
	elseif c=='['
	elseif c=='{'
	elseif c=='('
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
