struct Status
	onbegin::Function
	on::Function
	onend::Function
end
const 自发移动=Status(()->nothing,function(target::Entity,data::Dict{Symbol,Any})
	move(target,data[:x],data[:y])
end,()->nothing)
