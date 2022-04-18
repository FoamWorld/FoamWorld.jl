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
	tm=c_destroy_with(p.ib[p.chosen],blk)
	if (!lsetting[:break_all]) && tm==-1
		info_help(:game,:not_destroyable)
		return
	end
	if tm<4
		plydestroy(x,y)
		return
	end
	# 摧毁进程
	tm_quar=tm>>2
	cou=0
	t=@task begin
		while true
			sleep(0.5)
			cou+=1
			if cou>tm
				break
			end
		end
	end
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
