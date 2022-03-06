mutable struct LangData
	langs::Dict{Symbol,Dict{Symbol,Dict}}
end
struct SubLangData
	ref::Dict
end
function Base.getindex(l::LangData,key::Symbol)
	return SubLangData(l.langs[lsetting[:lang]][key])
end
function Base.getindex(l::SubLangData,keys...)
	d=l
	for key in keys
		if haskey(d.ref,key)
			@inbounds r=d.ref[key]
			if isa(r,Dict)
				d=SubLangData(r)
			else
				return r
			end
		else
			return "$key"
		end
	end
	return d
end
function load_langdata_fromdir!(ld::LangData,lang::Symbol,dirpath::String)
	ld.langs[lang]=Dict{Symbol,Dict}()
	li=readdir(dirpath;sort=false)
	for i in li
		ld.langs[lang][Symbol(i)]=read_code(joinpath(dirpath,i))
	end
end
