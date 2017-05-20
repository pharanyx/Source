module("pvp", package.seeall)


-- Project Source combat related functions


function set_target(self, target)
	tmp.target = target:title()

	e:echo("Targeting: " .. tmp.target)
	send("reject " .. tmp.target)
	send("unally " .. tmp.target)
	send("enemy " .. tmp.target)

	if tmp.mark_target then killTrigger(tmp.mark_target) end
	tmp.mark_target = tempTrigger(tmp.target, [[selectString("]] .. tmp.target .. [[", 1) bg("firebrick") fg("white") resetFormat()]])

	if tmp.leadermode then
		ps.to_channel("Target: " .. tmp.target)
		ps.to_channel("Target: " .. tmp.target)
		ps.to_channel("Target: " .. tmp.target)
	else
		ps.to_channel("Targeting: " .. tmp.target)
	end

	ui:update_statusbar()
end