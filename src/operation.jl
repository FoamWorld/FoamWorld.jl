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
