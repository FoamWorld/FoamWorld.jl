mutable struct 箱子<:固体
	ib::IB
end
箱子()=箱子(IB(16))
c_use(::箱子)=true
function use(b::箱子,::Int,::Int)
	global curui=build_blk_gui()
	gr=GtkGrid()
	push!(curui,gr)
	for i in 1:8
		gr[i,1]=GtkCanvas()
		gr[i,2]=GtkCanvas()
	end
	updg(b;grid=gr)
end
