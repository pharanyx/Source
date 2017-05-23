module("genrun", package.seeall)


-- Genrunner. Be careful :)

config = {}

function init(self, rs)
	if rs and type(rs) ~= "boolean" then
		ps.error("genrun:init() error. Supplied argument must be a boolean.")
		return
	end

	timing:start("genrun plot time")
	ps.echo("Genrunner plotting: " .. getRoomAreaName(getRoomArea(mmp.currentroom)) .. "...")
	
	local r = getAreaRooms(getRoomArea(mmp.currentroom))
	
	rooms = {}
	reverse_path = {}
	
	for _, vnum in ipairs(r) do
		if getPath(mmp.currentroom, vnum) then
			rooms[vnum] = {}
			local exits = getRoomExits(vnum)
			for direction, to_room in pairs(exits) do
				rooms[vnum][to_room] = {
					dir = direction,
				}
			end
		end
	end

	rooms[mmp.currentroom] = {}
	
	local exits = getRoomExits(mmp.currentroom)
	
	for direction, to_room in pairs(exits) do
		rooms[mmp.currentroom][to_room] = {
			dir = direction,
		}
	end

	rooms_left_to_touch = {}
	starting_room = mmp.currentroom
	
	for vnum, exits in pairs(rooms) do
		if vnum ~= starting_room then
			rooms_left_to_touch[vnum] = true
		end
	end

	ps.echo("Parsed " .. table.length(rooms_left_to_touch) .. " rooms. (Took " .. timing:stop("genrun plot time") .. ")\n")

	local area = gmcp.Room.Info.area
	local mobs = pve.mobs_by_area[area]

	ps.echo("Detected for this run:\n")
	ps.echo(concatand(mobs)..".\n")

	ps.echo("All set! Type 'ps genrun go' to start.")
	config.return_to_start = rs

	get_rooms_for_highlight(gmcp.Room.Info.area)

	raiseEvent("source genrun start")
end


function walk()
	for links_to, room_info in pairs(rooms[mmp.currentroom]) do
		if rooms_left_to_touch[links_to] then
			walking_to = links_to
			table.insert(reverse_path, mmp.currentroom)
			return mmp.gotoRoom(walking_to)
		end
	end
	
	backtrack()
end


function backtrack()
	backtracking = true
	if #reverse_path > 0 then
		walking_to = table.remove(reverse_path)
		return mmp.gotoRoom(walking_to)
	else
		ps.echo("Genrun for this area has been completed.")
		raiseEvent("source genrun completed")
	end
end


function stop()
	mmp.stop()
	walking = false
	rooms = {}
	walking_to = 0
	backtracking = false
	raiseEvent("source genrun stop")
	if genrun.config.return_to_start then
		ps.echo("Returning you to your starting room!")
		mmp.gotoRoom(starting_room)
	end
end


function continue()
	walking = true
	for k, v in pairs(tmp.roomitems) do
		local items_to_pickup = { "essence" }
		for _, i in ipairs(items_to_pickup) do
			if v.name:find(i) then
				send("get " .. i)
			end
		end
	end
  
	walk()
end


function arrived()
	if tmp.genrun then
		local vnum = gmcp.Room.Info.num
		
		unHighlightRoom(mmp.currentroom) 

		if vnum ~= walking_to then
			return
		end
	
		if backtracking then
			backtracking = false
		else
			rooms_left_to_touch[vnum] = nil
		end

		raiseEvent("source genrun arrived")
		walking = false
	end
end




