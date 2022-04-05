abstract type Material end
hard(m::Material)=mat数据[typeof(m).name.name][:hard]
function ltheme(m::Material)
	lt=mat数据[typeof(m).name.name][:lt]
	return RGB{N0f8}(lt[1],lt[2],lt[3])
end
function theme(m::Material)
	t=mat数据[typeof(m).name.name][:lt]
	return RGB{N0f8}(t[1],t[2],t[3])
end
function rtheme(m::Material)
	rt=mat数据[typeof(m).name.name][:lt]
	return RGB{N0f8}(rt[1],rt[2],rt[3])
end
macro material_types(s::Symbol...)
	for i in s
		eval(:(struct $i <: Material end))
	end
end
@material_types 苍穹木 石 粘土 陶瓷 铁 金 铜
