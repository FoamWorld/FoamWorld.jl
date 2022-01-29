mutable struct IB # 物品栏管理器
	l::Int
	n::Vector{UInt8}
	i::Vector{Item}
end
function IB(l::Int)
	return IB(l,zeros(UInt8,(l+1)>>1),[EI for i in 1:l])
end
function get_n(ib::IB,id::Int)::UInt8
	idd=(id+1)>>1
	return id&1==0 ? ib.n[idd]>>4 : ib.n[idd]&15
end
function set_n!(ib::IB,id::Int,x::UInt8)
	idd=(id+1)>>1
	id&1==0 ? ib.n[idd]=ib.n[idd]&15|(x<<4) : ib.n[idd]=ib.n[idd]&240|x
end
function get(ib::IB,id::Int)
	return Pair(ib.i[id],get_n(ib,id))
end
function set!(ib::IB,id::Int,x::Pair{Item,UInt8})
	ib.i[id]=x.first
	set_n!(ib,id,x.second)
end
function remove!(ib::IB,id::Int)
	ib.i[id]=EI()
end
function clear!(ib::IB)
	for i in 1:(ib.l+1)>>1
		ib.n[i]=0x0
	end
	for i in 1:ib.l
		ib.i[i]=EI()
	end
end
function reduce!(ib::IB,id::Int,n::Int)
	orin=get_n(ib,id)
	if n<orin
		set_n!(ib,id,orin-n)
	else
		ib.i[id]=EI()
	end
end
function give!(ib::IB,it::Item,n::Int)::Int
	last=n,st=stack(it),itid=id(it)
	for i in 1:ib.l
		if last==0
			return
		end
		iid=id(ib.i[i])
		if iid=="" # EI
			ib.i[i]=deepcopy(it)
			if last>st
				last-=st
				set_n!(ib,i,st)
			else
				set_n!(ib,i,last)
				return 0
			end
		elseif iid==itid
			orin=get_n(ib,i)
			if orin==st # 很可能出现
				continue
			elseif orin+last>st
				set_n!(ib,i,st)
				last-=(st-orin)
			else
				set_n!(ib,i,orin+last)
				return 0
			end
		end
	end
	return last
end
