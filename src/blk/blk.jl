abstract type Block end
id(b::Block)=String(typeof(b))
stack(b::Block)=0x4

struct 空气 end
struct 星岩 end

abstract type 岩石 end
