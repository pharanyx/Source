module("pdb", package.seeall)


-- Project Source player tracking database

schema = {
	people = {
		name          = "",
    	title         = "",
		gender        = "",
    	class         = "",
    	city          = "",
    	city_rank     = 0,
    	guild         = "",
    	might         = -1, 
    	xp_rank       = -1, 
    	level         = -1, 
    	immortal      = 0,
    	iff           = -1, 
    	cityenemy     = 0, 
    	orderenemy    = 0, 
    	guildenemy    = 0,
    	order         = "",
    	notes         = "",
    	endlevel      = 0,
    	race          = "",
    	birthday     = 0, 

    	_unique     = {"name"},
    	_violations = "REPLACE"
	},
}

function init()
	pdb.dbase = db:create("PlayerDB", schema)
	db.__conn["playerdb"]:execute("pragma synchronous = OFF")
	local test = db:fetch(pdb.dbase.people)
	if next(test) then
		local _,someperson = next(test)
    
		if someperson.order == nil then
			local conn = db.__conn.playerdb
			local sql_add = [[ALTER TABLE people ADD COLUMN "order" TEXT NULL DEFAULT ""]]
			conn:execute(sql_add)
			conn:commit()
			cecho("PlayerDB: Added field 'order'.\n")
		end

		if someperson.race == nil then
			local conn = db.__conn.playerdb
			local sql_add = [[ALTER TABLE people ADD COLUMN "race" TEXT NULL DEFAULT ""]]
			conn:execute(sql_add)
			conn:commit()
			cecho("PlayerDB: Added field 'race'.\n")
		end

		if someperson.endlevel == nil then
			local conn = db.__conn.playerdb
			local sql_add = [[ALTER TABLE people ADD COLUMN "endlevel" REAL NULL DEFAULT 0]]
			conn:execute(sql_add)
			conn:commit()
			cecho("PlayerDB: Added field 'endlevel'.\n")
		end

		if someperson.birthday == nil then
			local conn = db.__conn.playerdb
			local sql_add = [[ALTER TABLE people ADD COLUMN "birthday" REAL NULL DEFAULT 0]]
			conn:execute(sql_add)
			conn:commit()
			cecho("PlayerDB: Added field 'birthday'.\n")
		end

		if someperson.level == nil then
			local conn = db.__conn.playerdb
			local sql_add = [[ALTER TABLE people ADD COLUMN "level" REAL NULL DEFAULT 0]]
			conn:execute(sql_add)
			conn:commit()
			cecho("PlayerDB: Added field 'level'.\n")
		end
	end

	tempTimer(0, function()
		fixed_set(pdb.dbase.people.city, "rogue", db:eq(pdb.dbase.people.city, "(none)"))
		fixed_set(pdb.dbase.people.city, "rogue", db:eq(pdb.dbase.people.city, "none"))
		fixed_set(pdb.dbase.people.city, "rogue", db:eq(pdb.dbase.people.city, ""))
	end)
end

function fixed_set(field, value, query)
   local db_name = field.database
   local s_name = field.sheet

   local conn = db.__conn[db_name]

   local sql_update = [[UPDATE OR %s %s SET "%s" = %s]]
   if query then
       sql_update = sql_update .. [[ WHERE %s]]
   end

   local sql = sql_update:format(db.__schema[db_name][s_name].options._violations, s_name, field.name, db:_coerce(field, value), query)

   db:echo_sql(sql)
   assert(conn:execute(sql))
   if db.__autocommit[db_name] then
      conn:commit()
   end
end

init()

valid = valid or {}

valid.cities = {
  "Bloodloch", "Duiran", "Enorian", "Spinesreach"
}
valid.classes = {
  "Ascendril", "Shaman", "Luminary", "Templar", "Sentinel", "Zealot", "Shapeshifter", "Monk", "Syssin", "Wayfarer", "Praenomen", "Archivist", "Indorani", "Carnifex", "Sciomancer", "Teradrim"
}
valid.guilds = {
  "Sentaari", "Sentinels", "Templars", "Indorani", "Syssin", "Carnifex", "Teradrim", "Archivists", "Ascendril", "Sciomancers", "Shamans", "Illuminai"
}
valid.races = {
  "Arqeshi", "Atavian", "Dwarf", "Grecht", "Grook", "Human", "Horkval", "Imp", "Kelki", "Mhun", "Nazetu", "Ogre", "Orc", "Rajamala", "Troll", "Tsol'aa", "Xoran"
}


valid.cityranks = {
  Bloodloch = {
    ["Slayer of Orphans"] = 1,
    ["Envoy of Malice"] = 2,
    ["Advocate of the Undead"] = 3,
    ["Scourge of Malevolence"] = 4,
    ["Master of Carnage"] = 5,
    ["Imperator of Death"] = 6,
  },

  Duiran = {
    Councilor = 1,
    Pathfinder = 2,
    Waywatcher = 3,
    Warden = 4,
    Harbinger = 5,
    ["Elder of the Great Oak"] = 6,
  },

  Enorian = {
    Citizen = 1,
    Loyalist = 2,
    Patriot = 3,
    Veteran = 4,
    ["Warden of Light"] = 5,
    ["Harbinger of the Dawn"] = 6,
  },

  Spinesreach = {
    Proletarian = 1,
    Citizen = 2,
    Comrade = 3,
    Magister = 4,
    Provost = 5,
    Princeps = 6,
  }
}

for city, citydata in pairs(valid.cityranks) do
	for rank, rankn in pairs(citydata) do
		citydata[rankn] = rank
	end
end

function isvalidcity(self, which)
  which = which:title()
  return table.contains(valid.cities, which) and true or false
end

function isvalidguild(self, which)
  which = which:title()
  return table.contains(valid.guilds, which) and true or false
end

function isvalidclass(self, which)
  which = which:lower()
  return table.contains(valid.classes, which) and true or false
end

function isvalidrace(self, which)
  which = which:lower()
  return table.contains(valid.races, which) and true or false
end


function downloaded_file(self, _, filename)
  if not string.find(filename, "playerdb.html") then return end
  local f = io.open(filename)
  local s = f:read("*all")
  if f then f:close() end
  os.remove(filename)
  local name = filename:match("(%w+)-playerdb")
  local fullname = s:match([[<br />Full name: (.+)<br />City]])
  local level = s:match([[Level: (.-)<]])
  local city = s:match([[<br />City: (.+)<br />guild]])
  local guild = s:match([[<br />Guild: (.+)<br />Level]])
  local class = s:match([[<br />Class: (.+)<br />Mob]])
  local xp_rank = s:match([[Xp rank: (%d+)]])
  local endlevel
  local temp_name_list
  if s:find("I do not recognize that player.") then
    temp_name_list = {{
      name = name,
      xp_rank = -2,
    }}

  elseif level == nil then
    temp_name_list = {{
      name = name,
      immortal = 1
    }}
 
  else
    
    if tonumber(level) > 98 then endlevel = 1 else endlevel = 0 end
    if tonumber(xp_rank) == 0 then xp_rank = -2 end

    temp_name_list = {{
      name = name,
      class = class,
      endlevel = endlevel,
      title = fullname,
      level = level,
      immortal = 0,
      xp_rank = xp_rank and xp_rank or -1,
    }}
    if city ~= "(hidden)" then
    	  temp_name_list[1].city = (city ~= "(none)" and city or "rogue")
    end
    if not(guild == "(hidden)" or guild == "(none)") then
      temp_name_list[1].guild = guild
    end
  end
  db:merge_unique(db.people, temp_name_list)

  raiseEvent("playerdb finished honours")
end

function getinfo(self, person)
	downloadFile(getMudletHomeDir().."/"..person.."-namedb.html", "http://oldsite.ironrealms.com/game/honors/Aetolia/"..person)
end
