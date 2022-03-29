mutable struct 书
	data::Vector{String}
	page::Int
end
书()=书([""],1)
stack(::书)=0x1
c_use(::书)=true
one_use(::书)=false
function local_gb(s::String,f::Function)
	b=GtkButton(s)
	signal_connect(b,function() f(curuse) end,"clicked")
	return b
end
function use(i::书,::Target,::Target)
	global curui=build_itm_gui()
	gr=GtkGrid()
	push!(curui,gr)
	gr[1:11,1]=GtkTextView(;height_request=480)
	gr[1,2]=local_gb("<<",wfirst)
	gr[2,2]=local_gb("<",wprev)
	gr[3,2]=local_gb("-",wdel)
	gr[4,2]=local_gb("0",wclear)
	gr[5,2]=GtkTextView(;editable=false)
	gr[6,2]=GtkTextView(;editable=false,buffer=GtkTextBuffer(;text="/"))
	gr[7,2]=GtkTextView(;editable=false)
	gr[8,2]=local_gb("√",wsave)
	gr[9,2]=local_gb("+",wnew)
	gr[10,2]=local_gb(">",wnext)
	gr[11,2]=local_gb(">>",wlast)
	updg(i;grid=gr)
end
function updg(i::书;grid::GtkGrid=curui[1])
	set_gtk_property!(get_gtk_property(grid[1,1],:buffer,GtkTextBuffer),:text,i.data[i.page])
	set_gtk_property!(get_gtk_property(grid[5,2],:buffer,GtkTextBuffer),:text,i.page)
	set_gtk_property!(get_gtk_property(grid[7,2],:buffer,GtkTextBuffer),:text,length(i.data))
end
wsave(i::书)=i.data[i.page]=get_gtk_property(get_gtk_property(curui[1][1,1],:buffer,GtkTextBuffer),:text,String)
wnew(i::书)=begin push!(i.data,"");updg(i) end
wfirst(i::书)=begin i.page=1;updg(i) end
wlast(i::书)=begin i.page=length(i.data);updg(i) end
wclear(i::书)=begin i.data=[""];i.page=1;updg(i) end
wprev(i::书)=begin if i.page!=1 i.page-=1;updg(i) end end
wnext(i::书)=begin if i.page!=length(i.data) i.page+=1;updg(i) end end
wlast(i::书)=begin if i.page!=length(i.data) i.page+=1 end;updg(i) end
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
