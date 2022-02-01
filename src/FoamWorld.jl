module FoamWorld
using StaticArrays
using GtkObservables
# 宏变量
include("consts.jl")
include("globals.jl")

# 功能
include("lib_collide.jl")
include("lib_draw.jl")
include("lib_IB.jl")
include("lib_rand.jl")
include("lib_string.jl")
include("codes.jl")

# 内容
include("chunk.jl")
include("saves.jl")
include("tick.jl")

# 细节
include("blk/blk.jl")
include("ent/ent.jl")
include("gen/gen.jl")
include("itm/itm.jl")
include("mat/mat.jl")

end # module
