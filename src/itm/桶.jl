mutable struct 桶
	t::UInt8
end
id(i::桶)="桶$(i.t)"
text(i::桶)=String(装液体table[i.t])*langs[:name][:桶]
stack(::桶)=0x1
c_use(::桶)=true
function use(i::桶;par,needupdg::Bool)
	po=gpos_mouse()
	if po===nothing return end
	b=blk(dim,po.first,po.second)
	if i.t==0x0 # 接
		tb=typeof(b).name.name
		if haskey(装液体table,tb) return end
		if !lsetting[:inf_use]
			i.t=装液体table[tb]
			if needupdg updg(par) end
		end
		setblk(po.first,po.second,空气())
	elseif isa(b,空气) # 倒
		setblk(po.first,po.second,eval(装液体table[i.t])())
		if !lsetting[:inf_use]
			i.t=0x0
			if needupdg updg(par) end
		end
	end
end
