function inner_craft(its::Vector,lin=3,col=3)
	# 载入
	mat=Matrix{String}(undef,lin,col) # 辨识符
	filln=0x0 # 非空数
	for i in 1:lin
		for j in 1:col
			k=i*(col-1)+j
			mat[i,j]=its[k]
			if !isa(mat[i,j],EI)
				filln+=1
			end
		end
	end
# 左上角(mov_i,mov_j)
#=
	fl=false;mov_i=1;mov_j=1
	while mov_i<lin
		for j in 1:col
			if !isa(mat[mov_lin,j],EI)
				fl=true
				break
			end
		end
		if fl break end
		mov_i+=1
	end
	fl=false
	while mov_i<col
		for i in mov_j:lin
			if !isa(mat[i,mov_j],EI)
				fl=true
				break
			end
		end
		if fl break end
		mov_j+=1
	end
=#
	pattern=Vector{UInt8}()
	das=Vector{Item}(undef,filln)
	ids=Vector{String}(undef,filln)
	nas=Vector{String}(undef,filln)
	cou=1
	for i in 1:lin
		v=0
		for j in 1:col
			if !isa(mat[i,j],EI)
				das[cou]=mat[i,j]
				ids[cou]=id(mat[i,j])
				nas[cou]=mat[i,j].name.name
				v+=1<<(j-1)
				cou+=1
			end
		end
		if v!=0
			push!(pattern,v)
		end
	end
	res=Vector{Pair{Item,UInt8}}()
	# 检查普通合成表
	# [[3,1],["a1","a2","a3"],"a",2]
	for c in data[:普通合成表]
		if c[1]==pattern&&c[2]==ids
			push!(res,Pair(guess_struct(c[3]),length(c)==4 ? c[4] : 1))
		end
	end
	# 检查类合成表
	# [[3,1],[]]
	for c in data[:类合成表]
		if c[1]!=pattern
			continue
		end
		fl=false
		tarr=Vector{Union{UInt8,Nothing}}(nothing,4)
		for k in 1:length(c[2])>>1
			reqid::UInt8=c[2][k<<1-1]
			req=c[2][k<<1]
			if req!=nas[k]
				fl=true
				break
			elseif reqid!=0x0
				if tarr[reqid]===nothing
					tarr[reqid]=das[k].t
				elseif tarr[reqid]!=das[k].t
					fl=true
					break
				end
			end
		end
		if !fl
			str=c[3]
			s=replace(str,"\$"=>tarr[1])
			push!(res,Pair(guess_struct(s),length(c)==3 ? 0x1 : c[4]))
		end
	end
	return res
end
