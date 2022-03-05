function work_command(s::String)
	v::Vector{String}=split_cmd(s)
	name=popfirst!(v)
	if haskey(commands,name)
		pa::Pair=@inbounds commands[name]
		types=pa.first
		l=length(types)
		if length(v)!=l
			info_error(:cmd,:wrong_parameter_number)
		end
		for i in 1:l
			ty=types[i]
			if ty==:s # 字符串
			elseif ty==:i # 整数
				v[i]=parse(Int,v[i])
			end
		end
		pa.second(v...)
	else
		info_error(:cmd,:unfound_command)
	end
end
global commands=Dict{Symbol,Pair{Tuple,Function}}(
	:clear=>info_clear,
	:eval=>((:s),(s::String)->eval(Meta.parse(s))),
	:fill=>((:blk,:px,:py,:i,:i),(b::Block,lx::Int,ly::Int,nx::Int,ny::Int;restricted::Bool=true)->begin
		if restricted&&nx>64&&ny>64
			info_help(:cmd,:restriction)
			return
		end
		for i in 1:nx
			for j in 1:ny
				setblk(i+lx,j+ly,b)
			end
		end
	end),
	:give=>((:itm,:i),(i::Item,num::Int)->give!(ply.ib,i,num))
	:say=>((:s),(s::String)->info_log("$(gsetting[:username]): $s")),
)
