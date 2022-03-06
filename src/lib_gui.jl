function gui_init_all()
	global window=GtkWindow("Foam World",576,512;resizable=false,visible=false)
	signal_connect(gui_leave_all,window,"destroy")
end
function gtk_leave_all()
end
# 工具
gtk_showstr(s::String)=GtkTextView(;editable=false,buffer=GtkTextBuffer(;text=s))
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
function info_clear()
	global infobox=GtkBox(:h)
end
function info_log(s::String,color::RGB=RGB(0x0,0x0,0x0))
	push!(infobox,gtk_showstr(s))
end
function info_error(s::Symbol...;extra::String="")
	t=langs[:error][s...]
	if extra!=""
		t*=": $extra"
	end
	info_log(t,RGB(0xff,0x0,0x0))
end
function info_help(s::Symbol...;extra::String="")
	if gsetting[:show_help]
		t=langs[:help][s...]
		if extra!=""
			t*=": $extra"
		end
		info_log(t,RGB(0xff,0xff,0x0))
	end
end
