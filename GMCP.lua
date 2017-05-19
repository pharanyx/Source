module("GMCP", package.seeall)


-- Project Source GMCP handling

function keep_alive()
	sendGMCP("Core.KeepAlive")
	if tmp.keep_alive then
		killTimer(tmp.keep_alive)
	end
	tmp.keep_alive = tempTimer(60, [[GMCP:keep_alive()]])
end

keep_alive()


function parse_vitals()
	if not gmcp.Char.Vitals then return end

	core.vitals.last = {}

	for _, key in ipairs(tmp.vitals) do
		core.vitals.last[key] = core.vitals[key]
	end
	
	core.bals.last = {}

	for _, key in ipairs(tmp.bals) do
		core.bals.last[key] = core.bals[key]
	end

	for _, key in ipairs(tmp.bals) do
		core.bals[key] = gmcp.Char.Vitals[key] == "1" and true or false

		if core.bals[key] == true and core.bals.last[key] == false then
			if limiters[key] ~= nil then 
				core:fsoff(key)
			end
			timers.sets[key] = nil
		elseif core.bals[key] == false and core.bals.last[key] == true then
			timing:start(key)
		end
	end

	for _, key in ipairs(tmp.vitals) do
		if gmcp.Char.Vitals[key] then
			core.vitals[key] = tonumber(gmcp.Char.Vitals[key])
		end
	end


	core.vitals.levels = {
		ratios = {
			health = math.floor((gmcp.Char.Vitals.hp / gmcp.Char.Vitals.maxhp) * 100),
			mana = math.floor((gmcp.Char.Vitals.mp / gmcp.Char.Vitals.maxmp) * 100),
			endurance = math.floor((gmcp.Char.Vitals.ep / gmcp.Char.Vitals.maxep) * 100),
			willpower = math.floor((gmcp.Char.Vitals.wp / gmcp.Char.Vitals.maxwp) * 100)
		}
	}
end


function get_skillsets()
	core.skills = {}
	for _, set in ipairs(gmcp.Char.Skills.Groups) do
		local skills = string.format("Char.Skills.Get %s", yajl.to_string({ group = set.name }))
		sendGMCP(skills)
	end
	send("\n")
end


function populate_skill_tree()
	local group = gmcp.Char.Skills.List.group
	local list = gmcp.Char.Skills.List.list
	local newlist = {}
	for i, val in ipairs(list) do
		list[i] = val:gsub("* ", ""):lower()
	end

	if group then
		if not core.skills then core.skills = {} end
		core.skills[group] = list
		raiseEvent("gmcp skills done", group)
	end
end


function got_affliction()
local aff = "none" 
if not gmcp.Char.Afflictions.Add then return end

aff = gmcp.Char.Afflictions.Add.name

if aff == "sprawled" then aff = "prone" end

	e:got_aff(gmcp.Char.Afflictions.Add.name)
	raiseEvent("source got aff", gmcp.Char.Afflictions.Add.name)
end


function cured_affliction()
local aff = "none" 
if not gmcp.Char.Afflictions.Remove then return end

aff = gmcp.Char.Afflictions.Remove[1]

if aff == "sprawled" then aff = "prone" end

	e:cured_aff(gmcp.Char.Afflictions.Remove[1])
	raiseEvent("source cured aff", gmcp.Char.Afflictions.Remove[1])
end


function has_skill(group, skill)
	return true
end