mutable struct LangData
	langs::Dict{Symbol,Dict{Symbol,Dict}}
end
struct SubLangData
	ref::Dict
end
function getindex(l::LangData,key::Symbol)
	return SubLangData(l.langs[lsetting[:lang]][key])
end
function getindex(l::SubLangData,key)
	if haskey(l.ref,key)
		@inbounds r=l.ref[key]
		if isa(r,Dict)
			return SubLangData(r)
		else
			return r
		end
	else
		return "$key"
	end
end
function load_langdata_fromdir!(ld::LangData,lang::Symbol,dirpath::String)
	ld.langs[lang]=Dict{Symbol,Dict}()
	li=readdir(dirpath;sort=false)
	for i in li
		ld.langs[lang][Symbol(i)]=read_code(joinpath(dirpath,i))
	end
end
