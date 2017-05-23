module("defs", package.seeall)


-- Project Source defence related functions

current = {}

function add(self, def)
	current[def] = true
end

function remove(self, def)
	current[def] = nil
end

local menu_class = "endlevel"


-- Here, we define which classes have what skills

local skills = {
	["Archivist"]		= { "Geometrics", "Numerology", "Bioessence" },
	["Ascendril"]		= { "Elemancy", "Crystalism", "Enchantment" },
	["Carnifex"]		= { "Savagery", "Deathlore", "Warhounds" },
	["Indorani"]		= { "Necromancy", "Tarot", "Domination" },
	["Luminary"]		= { "Spirituality", "Devotion", "Illumination" },
	["Shapeshifter"]	= { "Ferality", "Shapeshifting", "Vocalizing" },
	["Monk"]			= { "Tekura", "Kaido", "Telepathy" },
	["Praenomen"]		= { "Corpus", "Mentis", "Sanguis" },
	["Sciomancer"]		= { "Sciomancy", "Crystalism", "Enchantment" },
	["Sentinel"]		= { "Dhuriv", "Woodlore", "Tracking" },
	["Shaman"]			= { "Primality", "Shamanism", "Naturalism" },
	["Syssin"]			= { "Assassination", "Subterfuge", "Hypnosis" },
	["Templar"]			= { "Battlefury", "Righteousness", "Bladefire" },
	["Teradrim"]		= { "Terramancy", "Animation", "Desiccation" },
	["Wayfarer"]		= { "Tenacity", "Wayfaring", "Fury" },
	["Zealot"]			= { "Tekura", "Telepathy", "Illumination" },
	["Azudim"]			= { "Miasma" },
	["Idreth"]			= { "Safeguard" },
    ["Yeleni"]			= { "Warmth" },
	["Free"]			= { "Curative", "Survival", "Vision", "Enchantment", "Tattoos" },
	["Artifact"]		= { "Artifact" }
}

function defup_display(self, style, profile, class)
	if ps.settings[style][profile][menu_class] == nil then
		ps.settings[style][profile][menu_class] = {}
	end
  
	local table_name = tostring(def)
	local sort_defs = {}
	local mana_use = {
    	"kai_trance",
    	"detection", 
    	"dodging", 
    	"mindnet",
		"eagleeye", 
		"vigilance", 
		"treewatch", 
		"telesense",
		"skywatch", 
		"hypersight", 
		"alertness", 
		"weaving",
		"projectiles"
  }

	local tx ={
		kai_trance = "Kai Trance",
		split_mind = "Split Mind"  ,
	}

	for k, _ in pairs(defs.deftable) do
		sort_defs[#sort_defs + 1] = k
	end

	table.sort(sort_defs)

	local x = 0

	for i, n in ipairs(sort_defs) do
		if defs.class_defcheck(n, class) then
			x = x + 1
			local d = "<dark_slate_gray>[<white>"
			if ps.settings[style][profile][menu_class][n] then
				if table.contains(mana_use, n) then
					d = d.."<red>M"
				else
					d = d.."X"
				end
			else 
				d = d.." "
			end
      
			d = d.."<dark_slate_gray>] <white>"     

			if (x - 1)%3 == 0 then
				echo("\n")
			end 
      
			cecho(d)
			local s = defs.deftable[n].name:title()
			if tx[n] then
				s = tx[n]
			end
      
			if s:len() < 25 and (x - 1)%3 ~= 2 then
				local pad = 25 - s:len()
				s = s..string.rep(" ", pad)
			elseif s:len() > 25 then
				s = s:cut(25)
			end
      
			fg("white") 
			local cmd

			if config == nil then
				config = "initial"
			end

			local al = "wconfig "..style.." "..profile.." "..menu_class.." "..n
			local cmd = [[expandAlias("]]..al..[[")]]
			echoLink(s, cmd, "Toggle defup of "..n, true)
		end
	end
	
	echo("\n")
end

function ps.class_defcheck(def, class)
  local ans = false
  for k,v in pairs(skills[class]) do
    ans = ans or table.contains(ps.tb.deftable[def]["skillset"], v)
  end
  return ans
end

function ps.showDefMenu(style, profile ,class)
  if class then
    menu_class = string.lower(class)
  else
    menu_class = ps.myClass()
  end
  ps.report(string.title(style) .. " config " .. profile .. " ("..menu_class..")")
  ps.report("Class Free Defs:")
  ps.defupDisplay(style, profile ,"free")
  ps.report(string.title(menu_class).." Defs:")
  ps.defupDisplay(style, profile, menu_class)
  ps.report("Artefacts:")
  ps.defupDisplay(style, profile, "artefact")
end

function ps.defToggle(style, profile, class, defname)
  if ps.settings.defup[profile][class] == nil then
    ps.settings.defup[profile][class] = {}
  end
  if ps.settings[style][profile][class][defname] ~= nil then
    ps.settings[style][profile][class][defname] = nil
    ps.report("Removed " .. defname .. " ("..ps.tb.deftable[defname]["name"] ..") from " ..style.. " in " ..profile.." profile")
    ps.showDefMenu(style, profile, class)
    send("curing priority defence " .. defname .. " reset", false)
  else
    ps.settings[style][profile][class][defname] = true
    ps.report("Added " .. defname .. " ("..ps.tb.deftable[defname]["name"] ..") to " ..style.. " in " ..profile.." profile")
    ps.showDefMenu(style, profile, class)
    --add stuff to serverside keepup if this is displaying a keepup list.
      if style == "keepup" and class == ps.myClass() then
        ps.settings.defprio[ps.profile][ps.myClass()][defname] = ps.settings.defprio[ps.profile][ps.myClass()][defname] or 25
        ps.enableSSDef( defname, ps.settings.defprio[ps.profile][ps.myClass()][defname], true )
      elseif style == "defup" and class == ps.myClass() then
        if not ps.settings.defprio[ps.profile][ps.myClass()][defname] then
           ps.settings.defprio[ps.profile][ps.myClass()][defname] = 25
        end
      end
  end
end

function ps.defprioDisplay()
  --init local tables
  local defpriolist = {}
  local defpriolistvals = {}
  local defpriolistsorted = {}

  --make sure defprio table exists
  if ps.settings.defup[ps.profile][ps.myClass()] == nil then
    ps.settings.defup[ps.profile][ps.myClass()] = {}
  end

  --snag all defup defs
  for k,v in pairs(ps.settings.defup[ps.profile][ps.myClass()]) do
    defpriolist[#defpriolist+1] = k
  end
  --snag all keepup defs
  for k,v in pairs(ps.settings.keepup[ps.profile][ps.myClass()]) do
    defpriolist[#defpriolist+1] = k
  end
  --check if there's a defprio table, if not make it
  if ps.settings.defprio[ps.profile][ps.myClass()] == nil then
    ps.settings.defprio[ps.profile][ps.myClass()] = {}
  end
  --assign prio # to all defs (25 if not set)
  for k,v in pairs(defpriolist) do
    if ps.settings.defprio[ps.profile][ps.myClass()][v] then
      defpriolistvals[v] = ps.settings.defprio[ps.profile][ps.myClass()][v]
    else
      defpriolistvals[v] = 25
    end
  end
  --put defs in new list to be sorted
  for index in pairs(defpriolistvals) do
    defpriolistsorted[#defpriolistsorted+1] = index
  end
  --sort defs by #
  table.sort(defpriolistsorted, function(a, b) return defpriolistvals[a] < defpriolistvals[b] end)
  
  --display results
  ps.report("Defence Priority order:")
  for k,v in ipairs(defpriolistsorted) do
    cecho("\n<white>"..defpriolistvals[v] .. "<dodger_blue>:<white> " .. v)
    local aliasone = "wconfig defprio " .. v .. " " .. defpriolistvals[v] - 1
    local cmdone = [[expandAlias("]]..aliasone..[[")]]
    echo(" ")
    echoLink("(-)", cmdone, "Move 'up' " .. v, true)
    echo(" ")
    local aliastwo = "wconfig defprio " .. v .. " " .. defpriolistvals[v] + 1
    local cmdtwo = [[expandAlias("]]..aliastwo..[[")]]
    echoLink("(+)", cmdtwo, "Move 'down' " .. v, true)
  end
end

function ps.defprioset(def, prio)
  if (tonumber(prio) > 0) and (tonumber(prio) < 26) then
    ps.settings.defprio[ps.profile][ps.myClass()][def] = prio
    if ps.settings.keepup[ps.profile][ps.myClass()][def] then
      ps.enableSSDef( def, prio, true )
    end
    ps.report("Set " .. def .. " to " .. prio .. " priority.")
  else
    ps.report("Cannot set a def lower than 1 or higher than 25 prio.")
  end
  ps.defprioDisplay()
end