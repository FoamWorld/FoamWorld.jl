mutable struct 书
	data::Vector{String}
	page::Int
end
书()=书([""],1)
stack(::书)=0x1
c_use(::书)=true
1_use(::书)=false
##
wsave(i::书,s::String)=i.data[i.page]=s
wnew(i::书,s::String)=begin w_save(i,s);push!(i.data,"");updg(i) end
wfirst(i::书,s::String)=begin w_save(i,s);i.page=1;updg(i) end
wlast(i::书,s::String)=begin w_save(i,s);i.page=length(i.data);updg(i) end
wclear(i::书,s::String)=begin w_save(i,s);i.data=[""];i.page=1;updg(i) end
wprev(i::书,s::String)=begin w_save(i,s);if i.page!=1 i.page-=1 end;updg(i) end
wlast(i::书,s::String)=begin w_save(i,s);if i.page!=length(i.data) i.page+=1 end;updg(i) end
function wdel(i::书)
	if length(i.data)==1
		i.data[1]=""
	else
		deleteat!(i.data,i.page)
		if i.page!=1
			i.page-=1
		end 
	end
	updg(i)
end
