module("defs", package.seeall)


-- Project Source defence related functions

current = {}

function add(self, def)
	current[def] = true
end

function remove(self, def)
	current[def] = nil
end