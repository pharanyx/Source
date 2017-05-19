module("timing", package.seeall)


-- Project Source timing framework.

function start(self, key)
	local time = getTime()
	
	timers.sets[key] = os_time()
end


function os_time()
	local t = getTime()

	return t.msec
		+ t.sec * 1000
		+ t.min * 1000 * 60
		+ t.hour * 1000 * 60 * 60
end


function stop(self, key, numeric)
	if timers.sets[key] == nil then
		return numeric and 0 or "ERR"
	end

	local time = os_time()
	local diff = time - timers.sets[key]

	if numeric then
		return diff
	end

	return time_diff(timers.sets[key], time)
end


function time_diff(start, stop)
	local diff = stop - start
	local outstring = ""

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

	outstring = ""

	if hours > 0 then outstring = outstring .. hours .. " hr " end
	if min > 0 then outstring = outstring .. min .. " min " end
	if sec > 0 then outstring = outstring .. sec .. " sec " end
	if msec > 0 then outstring = outstring .. msec .. " ms " end

	return outstring:gsub(".$", "")
end