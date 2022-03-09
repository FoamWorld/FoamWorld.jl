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
function work_command(s::String;commander=ply)
	v::Vector{String}=split_cmd(s)
	name=popfirst!(v)
	if haskey(command_alias,name)
		name=@inbounds command_alias[name]
	end
	if haskey(commands,name)
		pa::Tuple=@inbounds commands[name]
		types=pa[1]
		lt=length(types)
		lv=length(v)
		ld=pa[2]
		if lv>lt
			info_error(:cmd,:too_much_parameters;extra="$lv>$lt")
			return
		elseif lv<lt-ld
			info_error(:cmd,:too_little_parameters;extra="$lv<$lt-$ld")
			return
		end
		for i in 1:lv
			ty=types[i]
			if ty==:s # 字符串
			elseif ty==:i # 整数
				v[i]=parse(Int,v[i])
			elseif ty==:px # x坐标
				if v[i][1]=='~'
					v[i]=parse(Int,v[i][2:end])+commander.x
				else
					v[i]=parse(Int,v[i])
				end
			elseif ty==:py # y坐标
				if v[i][1]=='~'
					v[i]=parse(Int,v[i][2:end])+commander.y
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
		pa[3](v...)
	else
		info_error(:cmd,:unfound_command)
	end
end
global commands=Dict{Symbol,Tuple{Tuple,UInt8,Function}}(
	:clear=>((),0x0,info_clear),
	:eval=>((:s),0x0,(s::String)->eval(Meta.parse(s))),
	:fill=>((:blk,:px,:py,:i,:i),0x0,(b::Block,lx::Int,ly::Int,nx::Int,ny::Int;restricted::Bool=true)->begin
		if restricted&&nx>64&&ny>64
			info_help(:cmd,:restriction;extra=">64")
			return
		end
		for i in 1:nx
			for j in 1:ny
				setblk(i+lx,j+ly,deepcopy(b))
			end
		end
	end),
	:give=>((:itm,:i),0x1,(i::Item,num::Int=1)->give!(ply.ib,i,num))
	:say=>((:s),0x0,(s::String)->info_log("$(gsetting[:username]): $s")),
	:seed=>((),0x0,()->info_log(lsetting[:seed]))
)
const command_alias=Dict{Symbol,Symbol}(
	:clear_info=>:clear,
	:fill_override=>:fill,
	:show_seed=>:seed,
)
