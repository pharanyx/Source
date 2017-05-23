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
			if ps.limiters[key] ~= nil then 
				core:fsoff(key)
			end
			ps.timers.sets[key] = nil
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


	if gmcp.Char.Vitals.prone == "1" then
		if not affs:has("prone") then
			--tmp.last_stance = tmp.vitals.last.stance
		end

		affs:add("prone", true)
	else
		if affs:has("prone") then
			affs:cured("prone", true) 
		end
		
		tmp.last_stance = nil
	end

	if gmcp.Char.Vitals.blind == "1" then 
		--defs:add("blindness", true)
		affs.current.blindness = false
	else
		--defs:remove("blindness", true) 
	end

	if gmcp.Char.Vitals.deaf == "1" then
		--defs:add("deafness", true)
		affs.current.deafness = false
	else
		--defs:remove("deafness", true)
	end
	
	if gmcp.Char.Vitals.fangbarrier == "1" and not core:fscheck("fangbarrier") then 
		--defs:add("fangbarrier", true)
		affs.current.fangbarrier = false
	else 
		--defs:remove("fangbarrier", true)
	end
	
	if gmcp.Char.Vitals.cloak == "1" then
		--defs:add("cloak", true)
		affs.current.cloak = false
	else
		--defs:remove("cloak", true)
	end
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

 
function start_chat_record()
    local text = gmcp.Comm.Channel.Text.text
    text = ansi2decho(text)
    text = rex.gsub(text, mxpPattern, "")
    --decho(text)
end
 
--registerAnonymousEventHandler("gmcp.Comm.Channel.Text", "start_chat_record")


function chat_capture()
   local ch = gmcp.Comm.Channel.Start
   if not chat_channels then check_channels() end
   chat_channels.last = "Misc"
   for c, t in pairs(chat_channels.types) do
      if ch:find(c) then
         chat_channels.last = t
         break
      end
   end
   enableTrigger("comms capture")
end

function check_channels()
   chat_channels = chat_channels or {}
   chat_channels.last = chat_channels.last or ""
   chat_channels.types = {
      ["newbie"] = "Misc",
      ["market"] = "Misc",
      ["ct"] = "City",
      ["gt"] = "Guild", 
      ["gts"] = "Guild",
      ["clt"] = "Clans",
      ["cnt"] = "City",
      ["Web"] = "Combat",
      ["tell"] = "Tells",
      ["says"] = "Misc",
      ["ot"] = "Misc",
      ["emotes"] = "Misc"
   }
end


-- Items handling; both room and inv,

items = {}

function items:Add(event)
   local location = gmcp.Char.Items.Add.location
   if location ~= "inv" and location ~= "room" then
      location = location:match("%d+$")
   end
   local loc = location .. "_items"
   local item = {}
   for x, y in pairs(gmcp.Char.Items.Add.item) do 
      item[x] = y
   end
   if not self[loc] then
      sendGMCP("Char.Items.Inv")
      return
   end
   table.insert(self[loc], gmcp.Char.Items.Add.item)
   if loc == "inv_items" and item.attrib and item.attrib:find("c") then
      sendGMCP("Char.Items.Contents "..item.id)
   end
   return "source gmcp items add", location
end

function items:Remove()
   local location = gmcp.Char.Items.Remove.location
   if location ~= "inv" and location ~= "room" then
      location = location:match("%d+$")
   end
   local loc = location .. "_items"
   if not self[loc] then
      sendGMCP("Char.Items.Inv")
      return
   end
   for k, v in pairs(self[loc]) do
      if v.id == gmcp.Char.Items.Remove.item.id then
         table.remove(self[loc], k)
         break
      end
   end
   return "source gmcp items remove", location
end


function items:List()
   local location = gmcp.Char.Items.List.location
   if location ~= "inv" and location ~= "room" then
      location = location:match("%d+$")
   end
   local loc = location .. "_items"
   self[loc] = {}
   for k, v in pairs(gmcp.Char.Items.List.items) do
      local item = {}
      for x, y in pairs(v) do 
        item[x] = y
      end
      table.insert(self[loc], item)
      if loc == "inv_items" and v.attrib and v.attrib:find("c") then
         sendGMCP("Char.Items.Contents "..v.id)
      end
   end
   return "source gmcp items list", location
end


function items:Update()
   local location = gmcp.Char.Items.Update.location
   if location ~= "inv" and location ~= "room" then
      location = location:match("%d+$")
   end
   local loc = location .. "_items"
   local item = gmcp.Char.Items.Update.item
   local updated
      if not self[loc] then
      sendGMCP("Char.Items.Inv")
      return
   end
   for k, v in pairs(self[loc]) do
      if v.id == item.id then
         local item = {}
         for x, y in pairs(v) do 
            item[x] = y
         end
         self[loc][k] = item
         updated = true
         break
      end
   end
   if loc == "inv_items" and not updated then sendGMCP("Char.Items.Inv") end
   if loc == "inv_items" and item.attrib and item.attrib:find("c") then
      sendGMCP("Char.Items.Contents "..item.id)
   end
   return "source gmcp items update", location
end

function items:StatusVars()
   self.inv_items = {}
   self.room_items = {}
   sendGMCP("Char.Items.Inv")
   send("ql", false)
end

function items_event(self, event)
	local event = event:match("%w+$")
	local func = loadstring("return GMCP.items:"..event.."()")
	local x, y = func()
	tmp.invitems = GMCP.items.inv_items
	tmp.roomitems = GMCP.items.room_items
	if x then raiseEvent(x, y) end
end

function has_skill(group, skill)
	return true
end