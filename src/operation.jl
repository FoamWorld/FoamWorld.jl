function go_front(tar::Entity)
	l=steplength(tar)
	move!(tar,l*sin(tar.θ),-l*cos(tar.θ))
end
function go_back(tar::Entity)
	l=steplength(tar)
	move!(tar,-l*sin(tar.θ),l*cos(tar.θ))
end
go_north(tar::Entity)=move!(tar,0,-steplength(tar))
go_south(tar::Entity)=move!(tar,0,steplength(tar))
go_west(tar::Entity)=move!(tar,-steplength(tar),0)
go_east(tar::Entity)=move!(tar,steplength(tar),0)
turn_left(tar::Entity)=tar.θ-=π/12
turn_right(tar::Entity)=tar.θ+=π/12
"pos是已经过处理的地图坐标"
function mousedown(pos::Pair{Float,Float})
	bx=floor(pos.first)
	by=floor(pos.second)
	if !c_reach(ply,bx,by) return end
	plyclickblk(bx,by)
end
function plyclickblk(x::Int,y::Int,p::玩家=ply)
	blk=getblk(x,y)
	if isa(blk,气体)||isa(blk,液体)
		plyfill(x,y)
		return
	end
	tm=destroy_with(p.ib[p.chosen],blk)
	if (!lsetting[:break_all]) && tm==-1
		info_help(:game,:not_destroyable)
		return
	end
	if tm<4
		plydestroy(x,y)
		return
	end
	# 摧毁进程
	cou=0
	mouse_up=Channel{Nothing}(1)
	id=signal_connect(dcon,:mouse_release_event) do widget,event
		put!(mouse_up,nothing)
	end
	sur=CairoImageSurface(loadedimgs[:dig0])
	after_show[:d]=()->begin
		pos=get_show_pos(x,y)
		move_to(dcon,pos.first,pos.second)
		set_source_surface(dcon,sur)
	end
	t=@task begin
		while true
			sleep(0.5)
			cou+=1
			if !isempty(mouse_up)
				if cou>tm plydestroy(x,y)
				else info_help(:game,:not_enough_time)
				end
				break
			elseif cou>tm wait(mouse_up)
			elseif cou>tm>>2 sur=CairoImageSurface(loadedimgs[:dig1])
			elseif cou>tm>>1 sur=CairoImageSurface(loadedimgs[:dig2])
			end
		end
	end
	schedule(t)
	delete!(after_show,:d)
	signal_handler_disconnect(dcon,id)
end
function plyfill(x::Int,y::Int,p::玩家=ply)
	it=p.ib.i[p.chosen]
	blk=t_blk(it)
	if blk==missing return false
	else
		setblk(x,y,blk;player_put=true)
		if !lsetting[:inf_itm]
			reduce!(p.ib,p.chosen,1)
			updg(p)
		end
		return true
	end
end
function plydestroy(x::Int,y::Int,p::玩家=ply)
	setblk(x,y,空气())
end

function env_light()
#=
0.05s一帧，一昼夜32768帧，即27min 18.4s
round(sin(t/16384*π)*8+7.5)
=#
	t=UInt16(lsetting[:t]&32767)
	te=(t>16384 ? t-32768 : t)>>1
	res= te<327||te>7865 ? 0x0 :
	te<659||te>7533 ? 0x1 :
	te<1003||te>7189 ? 0x2 :
	te<1366||te>6826 ? 0x3 :
	te<1761||te>6431 ? 0x4 :
	te<2212||te>5980 ? 0x5 :
	te<2779||te>5413 ? 0x6 : 0x7
    return (t>16384) ? 0x7-res : res+0x8
end
