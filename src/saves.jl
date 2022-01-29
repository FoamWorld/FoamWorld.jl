function save_loc()
	loc=""
	if haskey(ENV,"FW_SAVE_LOC")
		loc=ENV["FW_SAVE_LOC"]
	else
		loc=ENV["APPDATA"]*"/FoamWorld/sav/"
		ENV["FW_SAVE_LOC"]=loc
	end
end
function save_game(g::Game,path::String=save_loc()*g.set["name"])
	if !isdir(path)
		mkdir(path)
	end
	cd(path)
	write_code("setting.fw",g.set)
end
function load_game(path::String)
	g=Game()
	cd(path)
	g.set=read_code("setting.fw")
end
