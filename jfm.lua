module("jfm", package.seeall)


-- Jagged Combat & Utility System
-- Project Start Date: 14th May 2017

-- Main System Module


-- Load system modules

function loadSystemModules()

	local path = package.path
	local cpath = package.cpath
	local home_dir = getMudletHomeDir()
	local lua_dir = string.format("%s/%s", home_dir, [[?.lua]])
	local init_dir = string.format("%s/%s", home_dir, [[?/init.lua]])
	local sysdir = string.format("%s/%s", getMudletHomeDir().."/jagged", [[?.lua]])
        
	package.path = string.format("%s;%s;%s;%s", path, lua_dir, init_dir, sysdir)
	package.cpath = string.format("%s;%s;%s;%s", cpath, lua_dir, init_dir, sysdir)

	local m = SYSROOT_DEFINED and { "affs", "core", "ui" } or nil
	for _, n in ipairs(m) do
		_G[n] = nil
		package.loaded[n] = nil
	end

	for _, n in ipairs(m) do
		local s, c = pcall(require, n)
		if not s then 
			display(c)
			jfm.error("Failed to load module: "..n..".lua. Please contact support.")
		end
		
		_G[n] = c

		jfm.echo("Module '"..n.."' loaded.\n")
	end

	package.path = path
	package.cpath = cpath
end


loadSystemModules()