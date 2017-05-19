module("pdb", package.seeall)


-- Project Source player database tracking

schema = {
	class = "unset",
	city = "unset",
	ally = false,
	enemy = false,
	guild = "unset",
	endlevel = false,
	order = "unset"
	level = "unset",
	fullname ="unset",
	xp_rank = "unset",
	race = "unset",
	in_alliance = false,
	in_area = false,
	in_room = false,
	colour = "<grey>",
	notes = "none"
}

players = {

}

add = function(self, name)
	local name = name:title()
	if not pdb.players[name] then
		pdb.players[name] = shallowcopy(pdb.schema)
		jfm.echo("Player database entry added for <SpringGreen>"..name..".")
		pdb:get_api_data(name)
	end
end

del = function(self, name)
	local name = name:title()
	pdb.players[name] = nil
	jfm.echo("Player database entry removed for <SpringGreen>"..name..".")
end

save = function()
	local sysdir = getMudletHomeDir().."/source/pdb/"
	table.save(sysdir.."playerdb.lua", pdb.players)
end

load = function()
	local sysdir = getMudletHomeDir().."/source/pdb/"
	table.load(sysdir .. "playerdb.lua", pdb.players)
	jfm.echo("Player database loaded.")
end

get_api_data = function (self, name)
	local name = name:title()
	local sysdir = getMudletHomeDir().."/source/pdb/"
	if not lfs.attributes(sysdir) then
		jfm.error("Character data folder not found or deleted!")
	else
		downloadFile(sysdir..name..".json", "http://api.aetolia.com/characters/"..name..".json")
	end
end

is_ally = function (self, name)
	local name = name:title()
	return pdb.players[name].ally == true and true or false
end

is_enemy = function (self, name)
	local name = name:title()
	return pdb.players[name].enemy == true and true or false
end

is_demigod = function (self, name)
	local name = name:title()
	return pdb.players[name].demigod == true and true or false
end

in_alliance = function (self, name)
	local name = name:title()
	return pdb.players[name].in_alliance == true and true or false
end

in_area = function (self, name)
	local name = name:title()
	return pdb.players[name].in_area == true and true or false
end

in_room = function (self, name)
	local name = name:title()
	return pdb.players[name].in_room == true and true or false
end


function got_pdb_data(self, _, fn)
	if not fn:find(".json", 1, true) then return end
	local file = io.open(fn, "r")
	local content = file:read "*a"
	local data = yajl.to_value(content)
	file:close()

	local ally_orgs = { 
		"Enorian", 
		"Duiran" 
	}

	local races = {
		"Arqeshi",
		"Atavian",   
		"Dwarf",    
		"Grecht",     
		"Grook",      
		"Human",         
		"Horkval",     
		"Imp",         
		"Kelki",       
		"Mhun",         
		"Nazetu",     
		"Ogre",       
		"Orc",       
		"Rajamala", 
		"Troll",      
		"Tsol'aa",      
		"Xoran",     
		"Tekal",       
		"Yeleni",      
		"Azudim",     
		"Idreth"
	}

	players[data.name].org = data.city:title()
	players[data.name].guild = data.guild
	players[data.name].demigod = tonumber(data.level) >= 100 and true or false
	players[data.name].in_alliance = table.contains(ally_orgs, data.city) and true or false
	players[data.name].ally = table.contains(ally_orgs, data.city) and true or false

	for _, v in ipairs(races) do
		if data.race:find(v) then
			players[data.name].race = v:title()
		end
	end
end



