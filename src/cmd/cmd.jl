function guess_struct(s::String)
	a=decode_get_parts(s)
	name=popfirst!(a)
	l=length(a)
	b=Vector{Any}(undef,l)
	for i in 1:l
		b[i]=decode(a[i])
	end
	f=eval(Symbol(name))
	if hasmethod(decoder,(f,Vector{Any}))
		return decoder(f(),b)
	else
		return f(b...)
	end
end
function work_command(s::String)
	v::Vector{String}=split_cmd(s)
	name=popfirst!(v)
	if haskey(commands,name)
		pa::Pair=@inbounds commands[name]
		types=pa.first
		l=length(types)
		lv=length(v)
		if lv!=l
			if lv>l info_error(:cmd,:too_much_parameters;extra="$lv>$l")
			else info_error(:cmd,:too_little_parameters;extra="$lv<$l")
			end
			return
		end
		for i in 1:l
			ty=types[i]
			if ty==:s # 字符串
			elseif ty==:i # 整数
				v[i]=parse(Int,v[i])
			elseif ty==:px # x坐标
				if v[i][1]=='~'
					v[i]=parse(Int,v[i][2:end])+ply.x
				else
					v[i]=parse(Int,v[i])
				end
			elseif ty==:py # y坐标
				if v[i][1]=='~'
					v[i]=parse(Int,v[i][2:end])+ply.y
				else
					v[i]=parse(Int,v[i])
				end
			elseif ty==:blk
				blk=guess_struct(v[i])
				if !isa(blk,Block)
					info_error(:cmd,:request_block;extra="#$i")
					return
				end
				v[i]=blk
			elseif ty==:itm
				sth=guess_struct(v[i])
				if isa(sth,Block)
					v[i]=IFB(sth)
				elseif !isa(sth,Item)
					info_error(:cmd,:request_item;extra="#$i")
					return
				end
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
			info_help(:cmd,:restriction;extra=">64")
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
	:seed=>((),()->info_log(lsetting[:seed]))
)
