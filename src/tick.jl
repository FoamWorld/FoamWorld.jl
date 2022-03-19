function onetick()
	lsetting[:time]+=lsetting[:tmove]
	lsetting[:t]+=1
end
function unload_chunks()
	plybx=(floor(ply.x)>>6)<<6
	plyby=(floor(ply.y)>>6)<<6
	nowtime=Dates.now().instant.periods.value
	for k in dim.cs
		if -128<=k.first.first-plybx<=128 && -128<=k.first.second-plyby<=128
			k.second.tm=0
		else
			tm=k.second.tm
			if tm==0
				k.second.tm=nowtime
			elseif nowtime-tm>60
				delete!(dim.cs,k.first)
			end
		end
	end
end
