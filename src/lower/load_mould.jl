global 模具cache=Dict{Symbol,Vector{UInt8}}()
function load_模具(s::Symbol;tarfile="data/shape/$s.shape")
	if haskey(模具cache,s)
		return @inbounds 模具cache[s]
	else
		io=open(tarfile,"r")
		v=Vector{UInt8}()
		sizehint!(v,256)
		readbytes!(io,v,256)
		close(io)
		模具cache[s]=v
		return v
	end
end
function fill_模具(v::Vector{UInt8},select::NTuple{4,ARGB32})
	mat=Matrix{ARGB32}(undef,32,32)
	for id in 0:255
		uint=v[id+1]
		i=id>>3+1
		j1=(id&7)<<2+1
		mat[i,j1]=select[uint&3+1]
		mat[i,j1+1]=select[uint>>2&3+1]
		mat[i,j1+2]=select[uint>>4&3+1]
		mat[i,j1+3]=select[uint>>6+1]
	end
	return mat
end
