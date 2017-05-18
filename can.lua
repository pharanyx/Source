module("can", package.seeall)


-- Can we do an action, or can't we?


cure = function ()
	return not core.paused 
		and not affs:has("stun")
		and not affs:has("petrified")
end

act = function ()
	return not affs:has("paralysis")
		and not affs:has("leftarmbroken")
		and not affs:has("rightarmbroken")
		and not affs:has("prone")
		and not affs:has("frozen")
		and not affs:has("petrified")
		and not affs:has("stun")
		and not affs:has("tangle")
end

herb = function ()
	return core.bals.herb
		and not fs:check("herb")
		and not affs:has("anorexia")
		and not affs:has("transfix")
		and not affs:has("asleep")
		and
			(affs:has("hypochondria")
		or
			core.precache
		or
			(not affs:has("gorged")
				and not affs:has("indifference")
				and not affs:has("destroyedthroat")
				and not affs:has("tangle")
				and not (affs:has("leftarmbroken") and affs:has("rightarmbroken"))
			)
		)
end

pipe = function ()
	return not affs:has("asthma")
			and core.bals.pipe
			and not fs:check("pipe")
			and not affs:has("asleep")
end

salve = function ()
	return core.bals.salve 
		and not fs:check("salve") 
		and not affs:has("slickness")
		and not affs:has("sandrot")
		and not affs:has("asleep")
end

elixir = function ()
	return core.bals.elixir
		and not fs:check("elixir")
		and not affs:has("anorexia")
		and not affs:has("asleep")
		and not affs:has("indifference")
end

focus = function ()
	return core.bals.focus
		and not fs:check("focus")
	 	and not core.systems.bashing
		and gmcp:hasSkill("Focusing")
		and not affs:has("impatience")
		and not affs:has("asleep")
end

stand = function ()
	return not affs:has("leftlegbroken")
		and not affs:has("rightlegbroken")
		and not affs:has("legbroken")
		and not affs:has("paralysis")
		and not affs:has("impale")
		and not affs:has("transfix")
		and not affs:has("bind")
		and not affs:has("hangedman")
		and not affs:has("web")
		and not affs:has("vines")
		and not affs:has("cocoon")
		and not affs:has("frozen")
		and not affs:has("asleep")
		and not affs:has("jawlock")
		and not affs:has("stun")
		and not affs:has("feed")
		and not affs:has("tangle")()
		and not affs:has("grappled")
		and not fs:check("stand")
		and not affs:has("unconscious")
		and core.bals.both()
end

kipup = function ()
	return not fs:check("kipup")
		and (core.vitals.class == "monk" or core.vitals.class == "zealot")
		and core.last_stance
		and not affs:has("paralysis")
		and not affs:has("frozen")
		and not affs:has("petrified")
		and not affs:has("stun")
end

writhe = function ()
	return not fs:check("writhe")
		and not affs:has("frozen")
		and not affs:has("stun")
		and not affs:has("asleep")
		and core.bals.writhe
end

sip = function ()
	return not affs:has("stun")
		and not affs:has("asleep")
		and not affs:has("anorexia")
		and not affs:has("indifference")
		and not affs:has("destroyedthroat")
end

refill = function ()
	return not affs:has("leftarmbroken")
		and not affs:has("rightarmbroken")
		and not fs:check("refill")
		and not affs:has("asleep")
		and core.bals.both()
end

tree = function ()
	return core.bals.tree
		and (core.tattoos and core.tattoos.tree)
		and not fs:check("tree")
		and not core.systems.bashing
		and (not affs:has("leftarmbroken") or not affs:has("rightarmbroken"))
		and 
		(
		affs:has("hypochondria")
		or
		(
		not affs:has("paralysis")
		and not affs:has("paresis")
		and not affs:has("asleep")
		))
end

renew = function ()
	return core.bals.renew
		and not fs:check("renew")
		and (gmcp.Char.Status.race == "ildreth" or gmcp.Char.Status.race == "yeleni" or gmcp.Char.Status.race == "azudim")
		and not core.systems.bashing

		and 
		(
		affs:has("hypochondria")
		or
		(
		not affs:has("asleep")
		))
end

clot = function ()
	return not affs:has("stun")
		and not affs:has("asleep")
		and not affs:has("frozen")
		and not affs:has("petrified")
		and not affs:has("haemophilia")
end

shrug = function ()
	return core.bals.shrug
		and gmcp:hasSkill("Shrugging")
		and not affs:has("stunnded")
		and not affs:has("asleep")
		and not affs:has("frozen")
		and not affs:has("petrified")
		and not fs:check("shrug")
end

parry = function ()
	return core.bals.equilibrium
		and core.bals.balance
		and not fs:check("parry")
		and not affs:has("paralysis")
		and not affs:has("prone")
		and not affs:has("frozen")
		and not affs:has("petrified")
		and not affs:has("stun")
		and not affs:has("tangle")()
		and (
			gmcp:hasSkill("Parrying")
			or gmcp:hasSkill("Pawguard")
			 or gmcp:hasSkill("Guarding")
		)
end

target = function ()
	return not affs:has("paralysis")
		and not affs:has("prone")
		and not affs:has("frozen")
		and not affs:has("petrified")
		and not affs:has("stun")
		and not affs:has("impale")
		and not affs:has("transfix")
		and not affs:has("bind")
		and not affs:has("hangedman")
		and not affs:has("web")
		and not affs:has("vines")
		and not affs:has("cocoon")
		and not affs:has("frozen")
		and not affs:has("asleep")
		and not affs:has("jawlock")
		and not affs:has("feed")
		and not affs:has("grappled")
end

mount = function ()
	return gmcp:hasSkill("Quickmounting")
		and core.settings.entities.horse ~= "0"
		and not core.defs.active.shapeshifter  
		and core.vitals.class ~= "monk" and core.vitals.class ~= "zealot"
		and core.systems.mounting
end

overwhelm = function ()
	return pvp:affs("prone")
		 or pvp:affs("paralysis")
		 or pvp:affs("writhe")
end

bash = function ()
	return core.bals:both()
		and can:act()
end