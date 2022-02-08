mutable struct 桶
	t::UInt8
end
id(i::桶)="桶$(i.t)"
stack(::桶)=0x1
c_use(::桶)=true
function use(i::桶;par,needupdg::Bool)
	po=gpos_mouse()
	if po===nothing return end
	b=blk(dim,po.first,po.second)
	if i.t==0x0 # 接
		if !isa(b,液体) return end
		if !lsetting[:inf_use]
			i.t=装液体table[typeof(b).name.name]
			if needupdg updg(par) end
		end
		makeblk(po.first,po.second,空气())
	elseif isa(b,空气) # 倒
		makeblk(po.first,po.second,eval(装液体table[i.t])())
		if !lsetting[:inf_use]
			i.t=0x0
			if needupdg updg(par) end
		end
	end
end
