function split_cmd(s::String)
	v=[];t="";quo=false
	l=length(s)
	for i in 1:l
		if s[i]==' '&&!quo
			if t!=""
				push!(v,t)
				t=""
			end
			continue
		end
		if s[i]=='\\'
			if s[i+1]=='\\'
				i+=1
				t*='\\'
			elseif s[i+1]=='\`'
				i+=1
				t*='\`'
			end
		elseif s[i]=='`'
			quo=!quo
		else
			t*=s[i]
		end
	end
	if t!=""
		push!(v,t)
	end
	return v
end
function en_str(s::String)
	e=""
	for i in s
		if i=='#'
			e*="#i"
		elseif i=='"'
			e*="#q"
		elseif i=='\n'
			e*="#n"
		elseif i=='\t'
			e*="#t"
		elseif i=='\r'
			e*="#r"
		else
			e*=i
		end
	end
	return e
end
function de_str(s::String)
	d="";mark=false
	for i in s
		if mark
			if i=='i'
				d*='#'
			elseif i=='q'
				d*='"'
			elseif i=='n'
				d*='\n'
			elseif i=='t'
				d*='\t'
			elseif i=='r'
				d*='\r'
			end
			mark=false
			continue
		end
		if i=='#'
			mark=true
		else
			d*=i
		end
	end
	return d
end
function clean_str(s::String)
	a=""
	for i in s
		if i!='\t'&&i!='\n'&&i!='\r'
			a*=i
		end
	end
	return a
end
