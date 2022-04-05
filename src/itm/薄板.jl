mutable struct 薄板<:零件
	mat::Material
end
function i_show_l(i::薄版,ctx::DrawContext)
	fill_rect(ctx;color=theme(i.mat))
end
