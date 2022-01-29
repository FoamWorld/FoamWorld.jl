global srand_core=zero(UInt32)
function srand(x::Integer)
	global srand_core=UInt32(x)
end
function crand()
	global srand_core=(srand_core*1103515245+12345)
	return (srand_core>>16)&32767
end
"[l,r]"
function crandom(l::Int,r::Int)
	return l+crand()%(r-l+1)
end
"[l,r]中与l,r同奇偶"
function crandom_even(l::Int,r::Int)
	return l+(crand()%((r-l)>>1+1))<<1
end
