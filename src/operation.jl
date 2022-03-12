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
