const FW_VERSION=v"0.3.0-alpha"
#=
+-----x
|5 1 6
|4   2
|8 3 7
y
=#
const direx=[0,1,0,-1,-1,1,1,-1],
direy=[-1,0,1,0,-1,-1,1,1],
dirl=[4,1,2,3,8,5,6,7],
dirr=[2,3,4,1,6,7,8,5],
diroppo=[3,4,1,2,7,8,5,6]

const Target=Union{Entity,Block}
