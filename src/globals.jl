global gsetting, # 泛设置
langs, # 当前语言内容
data, # 当前打开的数据
game, # 当前游戏
lsetting, # 当前游戏设置
ply, # 当前玩家
dim, # 当前维度
saved, # 当前保存数据 saved[维度名]=data
sav, # 当前维度保存数据 sav[区块坐标（64倍数）][相对坐标编码（索引1）]=方块数据（引用）
ltemp, # 临时数据表
curpage, # 当前页名称
window, # 当前窗口
winbox, # window下的box
curui, # 当前打开的GUI板
dcon, # 画板上下文
loadedimgs, # 已加载的图片
after_show=Dict{Symbol,Function}(), # show后调用
curuse # 当前使用的东西
