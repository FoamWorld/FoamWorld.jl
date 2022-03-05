function gui_init_all()
	global window=GtkWindow("Foam World",576,512;resizable=false,visible=false)
	signal_connect(gui_leave_all,window,"destroy")
end
function gtk_leave_all()
end
# 主菜单
function gui_主菜单_init()
	global winbox=GtkBox(:v)
	push!(window,winbox)
	lc=langs[:choice]
	but_set=GtkButton(lc[:to_setting]);push!(winbox,but_set)
	but_new=GtkButton(lc[:to_newgame]);push!(winbox,but_new)
	but_open=GtkButton(lc[:to_open]);push!(winbox,but_open)
	signal_connect(gui_主菜单_click_set,but_set,"clicked")
	signal_connect(gui_主菜单_click_new,but_new,"clicked")
	signal_connect(gui_主菜单_click_open,but_open,"clicked")
end
function gui_主菜单_click_set()
	global curpage=:设置
	gui_设置_init()
end
# setting
function gui_设置_init()
	set_username_box=Box(:h)
end
# game
function info_log(s::String)
end
info_error(s::Symbol)=info_log(langs[:error][s])
info_help(s::Symbol)=info_log(langs[:help][s])
