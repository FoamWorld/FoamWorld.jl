function inner_craft(its::Vector,lin=3,col=3)
	# 载入
	mat=Matrix{Union{Item,Nothing}}(nothing,lin,col)
	for i in 1:lin
		for j in 1:col
			mat[i,j]=its[i*(col-1)+j]
		end
	end
	# 移到左上角
	fl=false;mov_lin=1;mov_col=1
	while mov_lin<lin
		for j in 1:col
			if !isa(mat[mov_lin,j],EI)
				fl=true
				break
			end
		end
		if fl break end
		mov_lin+=1
	end
	fl=false
	while mov_col<col
		for i in mov_lin:lin
			if !isa(mat[i,mov_col],EI)
				fl=true
				break
			end
		end
		if fl break end
		mov_col+=1
	end
	for i in mov_lin:lin
		for j in mov_col:col
			mat[i-mov_lin+1,j-mov_col+1]=mat[i,j]
			mat[i,j]=nothing
		end
	end
	res=[]
	# 检查普通合成表
	for c in data[:普通合成表]
	end
end
