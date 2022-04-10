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
function clean_str(s::String)
	a=""
	for i in s
		if i!='\t'&&i!='\n'&&i!='\r'
			a*=i
		end
	end
	return a
end
function esc_str2(io::IO,s::AbstractString)
	for c::AbstractChar in s
		c=='"' ? print(io,"\\=") :
		c=='\'' ? print(io,"\\-") :
		c=='\0' ? print(io,"\\0") :
		c=='\e' ? print(io,"\\e") :
		c=='\\' ? print(io,"\\/") :
		'\a'<=c<='\r' ? print(io,'\\',"abtnvfr"[Int(c)-6]) :
		print(io,c)
	end
end
esc_str2(s::AbstractString)=sprint(escape_string,s;sizehint=lastindex(s))
