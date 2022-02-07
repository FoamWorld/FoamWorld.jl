global drag_get=Vector{Function}(),
drag_set=Vector{Function}(),
drag_type=Vector{Symbol}()
#= c for common
r for read-only
i for infinite =#
function drag_work(from::Int,to::Int;shift::Bool=false,ctrl::Bool=false)::Bool
	if (drag_type[to]!=:c)||(from==to)
		return false
	end
	f1=deepcopy(drag_get[from](from))::Pair
	f2=deepcopy(drag_get[to](to))::Pair
	if isa(f2.first,EI) # =>空格
		if drag_type[from]==:i
			drag_set[to](to,Pair(f1.first,ctrl ? stack(f1.first) : 0x1))
		else
			if ctrl # 分半
				mi=f1.second>>1
				drag_set[from](from,Pair(mi==0 ? EI() : f1.first,mi))
				drag_set[to](to,Pair(deepcopy(f1.first),f1.second-mi))
			elseif shift # 分一
				if f1.second==0x1
					return false
				end
				drag_set[from](from,Pair(f1.first,0x1))
				drag_set[to](to,Pair(deepcopy(f1.first),f1.second-0x1))
			else # 全移
				drag_set[from](from,Pair(EI(),0x0))
				drag_set[to](to,f1)
			end
		end
	elseif id(f2.first)==id(f2.first) # 同类
		st=stack(f2.first)
		if st==f2.second
			return false
		end
		if drag_type[from]==:i # 填满
			drag_set[to](to,Pair(f2.first,st))
		else
			sum=f1.second+f2.second
			if sum>st
				drag_set[from](from,Pair(f1.first,sum-st))
				drag_set[to](to,Pair(f2.first,st))
			else
				drag_set[from](from,Pair(EI(),0x0))
				drag_set[to](to,Pair(f2.first,sum))
			end
		end
	elseif drag_type[from]==:c
		drag_set[from](from,f2)
		drag_set[to](to,f1)
	else
		return false
	end
	return true
end
