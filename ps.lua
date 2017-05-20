module("ps", package.seeall)


-- Project Source Combat & Utility System
-- Project Start Date: 14th May 2017

-- Main System Module


-- Load system modules

function load_system_modules()

	local path = package.path
	local cpath = package.cpath
	local home_dir = getMudletHomeDir()
	local lua_dir = string.format("%s/%s", home_dir, [[?.lua]])
	local init_dir = string.format("%s/%s", home_dir, [[?/init.lua]])
	local sysdir = string.format("%s/%s", getMudletHomeDir().."/source", [[?.lua]])
        
	package.path = string.format("%s;%s;%s;%s", path, lua_dir, init_dir, sysdir)
	package.cpath = string.format("%s;%s;%s;%s", cpath, lua_dir, init_dir, sysdir)

	local m = SYSROOT_DEFINED and { "affs", "can", "core", "genrun", "GMCP", "log", "pdb", "pvp", "rc4", "ss", "timing", "ui" } or nil
	for _, n in ipairs(m) do
		_G[n] = nil
		package.loaded[n] = nil
	end

	for _, n in ipairs(m) do
		local s, c = pcall(require, n)
		if not s then 
			display(c)
			ps.error("Failed to load module: "..n..".lua. Please contact support.")
		end
		
		_G[n] = c

		ps.echo("Module '"..n.."' loaded.")
	end

	package.path = path
	package.cpath = cpath

	raiseEvent("source done loading")
end


load_system_modules()