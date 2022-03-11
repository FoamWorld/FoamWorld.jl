mutable struct 桶
	t::UInt8
end
id(i::桶)="桶$(i.t)"
text(i::桶)=String(data[:装液体table][i.t])*langs[:name][:桶]
stack(::桶)=0x1
c_use(::桶)=true
function use(i::桶,user::Target,::Target)
	po=gpos_mouse()
	if po===nothing return end
	b=blk(dim,po.first,po.second)
	if i.t==0x0 # 接
		tb=typeof(b).name.name
		if haskey(data[:装液体table],tb) return end
		if !lsetting[:inf_use]
			i.t=data[:装液体table][tb]
			updg(user)
		end
		setblk(po.first,po.second,空气())
	elseif isa(b,空气) # 倒
		setblk(po.first,po.second,eval(data[:装液体table][i.t])())
		if !lsetting[:inf_use]
			i.t=0x0
			updg(user)
		end
	end
end
