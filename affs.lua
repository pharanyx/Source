module("affs", package.seeall)


-- Project Source Affliction Handling

current = {}

function got()
local aff = "none" 
if not gmcp.Char.Afflictions.Add then return end

aff = gmcp.Char.Afflictions.Add.name

if aff == "sprawled" then aff = "prone" end

	current[aff] = {
		when = os.clock(),
		tried_cure = 0,
		attempt_cure = 0 
	}
	
	ps.got_aff(gmcp.Char.Afflictions.Add.name)
	raiseEvent("source got aff", gmcp.Char.Afflictions.Add.name)
end


function cured()
local aff = "none" 
if not gmcp.Char.Afflictions.Remove then return end

aff = gmcp.Char.Afflictions.Remove[1]

if aff == "sprawled" then aff = "prone" end

	current[aff] = nil
	ps.cured_aff(gmcp.Char.Afflictions.Remove[1])
	raiseEvent("source cured aff", gmcp.Char.Afflictions.Remove[1])
end

function has(aff)
	return affs.current[aff] and true or false
end


