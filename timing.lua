module("timing", package.seeall)


-- Project Source timing framework.

function start(self, key)
	local time = getTime()
	
	ps.ps.timers.sets[key] = os_time()
end


function os_time()
	local t = getTime()

	return t.msec
		+ t.sec * 1000
		+ t.min * 1000 * 60
		+ t.hour * 1000 * 60 * 60
end


function stop(self, key, numeric)
	if ps.timers.sets[key] == nil then
		return numeric and 0 or "ERR"
	end

	local time = os_time()
	local diff = time - ps.timers.sets[key]

	if numeric then
		return diff
	end

	return time_diff(ps.timers.sets[key], time)
end


function time_diff(start, stop)
	local diff = stop - start
	local out = ""

	if numeric then
		return diff
	end

	local hours = math.floor(diff/(1000 * 60 * 60))
	diff = diff - (hours * 1000 * 60 * 60)

	local min = math.floor(diff/(1000 * 60))
	diff = diff - (min * 1000 * 60)

	local sec = math.floor(diff/(1000))
	diff = diff - (sec * 1000)

	local msec = diff

	out = ""

	if hours > 0 then out = out .. hours .. " hr " end
	if min > 0 then out = out .. min .. " min " end
	if sec > 0 then out = out .. sec .. " sec " end
	if msec > 0 then out = out .. msec .. " ms " end

	return out:gsub(".$", "")
end