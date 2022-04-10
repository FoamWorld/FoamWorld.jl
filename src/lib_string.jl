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
esc_str2(s::AbstractString)=sprint(esc_str2,s;sizehint=lastindex(s))
function unesc_str2(io::IO,s::AbstractString)
	a=Iterators.Stateful(s)
	for c in a
		if !isempty(a) && c=='\\'
			c=popfirst!(a)
			if c=='x'||c=='u'||c=='U'
				n=k=0
				m=c=='x' ? 2 : c=='u' ? 4 : 8
				while (k+=1)<=m && !isempty(a)
					nc=peek(a)
					n='0'<=nc<='9' ? n<<4+(nc-'0') : 'a'<=nc<='f' ? n<<4+(nc-'a'+10) : 'A'<=nc<='F' ? n<<4+(nc-'A'+10) : break
					popfirst!(a)
				end
				if k==1 || n>0x10ffff
					u=m==4 ? 'u' : 'U'
					throw(ArgumentError("invalid $(m==2 ? "hex (\\x)" : "unicode (\\$u)") escape sequence"))
				end
				if m==2 # \x
					write(io,UInt8(n))
				else
					print(io,Char(n))
				end
			elseif '0'<=c<='7'
				k=1
				n=c-'0'
				while (k+=1)<=3 && !isempty(a)
					c=peek(a)
					n=('0'<=c<='7') ? n<<3+c-'0' : break
					popfirst!(a)
				end
				if n>255 throw(ArgumentError("octal escape sequence out of range")) end
				write(io,UInt8(n))
			else
				print(io,c=='a' ? '\a' : c=='b' ? '\b' : c=='t' ? '\t' : c=='n' ? '\n' : c=='v' ? '\v' : c=='f' ? '\f' : c=='r' ? '\r' : c=='e' ? '\e' :
				c=='/' ? '\\' : c=='=' ? '"' : c=='-' ? '\'' : c=='|' ? '`' : throw(ArgumentError("invalid escape sequence \\$c")))
			end
		else
			print(io,c)
		end
	end
end
unesc_str2(s::AbstractString)=sprint(unesc_str2,s;sizehint=lastindex(s))
