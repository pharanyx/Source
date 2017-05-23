module("core", package.seeall)


-- Project Source Core System Functions


-- Core System Variables

bals = {}
font_size = "12px"
realm = "Aetolia"
state = "Active"
ui_font = "Hack"
version = "0.9.1"
vitals = {}

-- Priority queue

priority_queue = {
    __index = {
        push = function(self, v, p)
            local q = self.prios[p]
            if not q then
                q = {first = 1, last = 0}
                self.prios[p] = q
            end
            q.last = q.last + 1
            q[q.last] = v
			self.counter = self.counter + 1
        end,
        pop = function(self)
            for p, q in pairs(self.prios) do
                if q.first <= q.last then
                    local v = q[q.first]
                    q[q.first] = nil
                    q.first = q.first + 1
					self.counter = self.counter - 1
                    return v, p
                else
                    self.prios[p] = nil
                end
            end
		end,
		isempty = function(self)
			return self.counter == 0
		end

    },
    __call = function(cls)
        return setmetatable({
			prios = {},
			counter = 0
		}, cls)
    end
}

setmetatable(priority_queue, priority_queue)


-- Event delegation

queue = priority_queue()

function send_prio(self, command, priority, ret)
	
    prio = priority or 100
    
    if ret then
	   ps.echo("Added '" .. command:upper() .. "' with a priority of: " .. prio..".")
	end

    if not core:fscheck("send look on queue") then
        send("\n")
        core:fson("send look on queue", 3)
    end

    queue:push(command, prio)
end

function prompt()
	raiseEvent("act")
	while not queue:isempty() do
		local command = queue:pop()

        if type(command) == "function" then
            _G[command]()
        else
		  send(command)
        end
	end
end

registerAnonymousEventHandler("source prompt received", "core.prompt")


-- Failsafe Timing Functions

function fson(self, key, time)    
    if ps.timers[key] then
        killTimer(ps.timers[key])
    end
    
    ps.limiters[key] = true
    local delay = time or 0.5
    if ps.flags.aeon then
        delay = delay + 1.5
    end
    ps.timers[key] = tempTimer(delay, [[core:fsoff("]]..key..[[")]])
end

function fsoff(self, key)
    if ps.limiters[key] ~= nil then
        if ps.timers[key] then
            killTimer(ps.timers[key])
        end
        ps.limiters[key] = false
        ps.timers[key] = nil
    end
end

function fscheck(self, key)
    return ps.limiters[key] and true or false
end


-- System tips table

tips = {
    "You can quickly and easily execute a Lua command by prepending an exclamation mark, i.e. '!display(gmcp)'",
    "Need to be alerted of an important event? Try the system warning label feature, ui:event_label(). Takes up to two arguments, the text to display and the duration of the label in seconds",
    "Have a line you wish to highlight? ui:combat_echo() is your friend. First argument is the text to display. Second and third aruments are optional, but define the colour and the width of the highlight. Available colours include red, blue, green, yellow, purple and orange",
    "A full overview of the current system settings can be seen with 'ps settings show'",
    "Create simple, unobtrusive highlights with the ui:oecho() function.",
    "Did you know that clicking the character information component will cycle through the available themes?",
    "Want to see the player database data for a name? Simply 'whois <name>' to view all held records.",
    "Player database settings can be found via 'ps pdb show' - Assign alliances and set colours for a multitude of states and affiliations.",

}


function show_tip()
    local delay = tempTimer(10, [[ps.showtip(core.tips[math.random(#core.tips)])]])
end


-- Function taken from http://lua-users.org/wiki/CompareTables

function table.compare(t1, t2, orderby, n1, n2, fmt1, fmt2, compf, dupe, callback, callback2)
    local t1 = t1 or nil
    local t2 = t2 or nil

    if t1[1] == nil then ps.error("The first table is empty or not index based (t1[1] == nil)") return nil, 0 end
    if t2[1] == nil then ps.error("The second table is empty or not index based (t2[1] == nil)") return nil, 0 end

    local comp = {}   
    local counter = 0
    local list = {}
    local listlast = orderby:gsub("([^,]*)[,]", function(s) table.insert(list, s) return "" end )
    
    table.insert(list, listlast) 
   
    for i, v in ipairs(list) do 
        list[i] = {} 
        if i == 1 then
            v = v:gsub("^ORDER BY ",""):gsub("^order by ","")
        end
        list[i].name = v:gsub("^%s+",""):gsub("%s+$","")    
        local _, c = list[i].name:gsub("%w+","")
        if c>1 then
            list[i].name = list[i].name:gsub("%s.*$","") 
            list[i].desc = true 
        end
    end

    local function alias(nn, field) 
        if #nn == 0 then 
        return field  else return nn[field]
        end
    end
    local fmt1 = fmt1 or function(s) return s end
    local fmt2 = fmt2 or function(s) return s end

    local t1x = {}
    local t2x = {}
    for i, v in ipairs(t1) do
        t1x[i] = {}
        t1x[i]._i = i  
        for j,field in ipairs(list) do
            t1x[i][field.name] = fmt1( v[ alias(n1,field.name) ] ) 
        end
    end
    for i, v in ipairs(t2) do
        t2x[i] = {}
        t2x[i]._i = i 
        for j, field in ipairs(list) do
            t2x[i][field.name] = fmt2( v[ alias(n2, field.name) ] )
        end
    end

    local sf = function (a,b)
        for i, v in ipairs(list) do
            if a[v.name] ~= b[v.name] then
                if v.desc then
                    return a[v.name] > b[v.name]
                else
                    return a[v.name] < b[v.name]
                end
            end
        end
        return a._i < b._i
    end

    table.sort(t1x, sf)
    table.sort(t2x, sf)

    local i2 = 1
    local v1f_previous = ""
    local found = false

    local cfc = compf or function(a, b) return a==b end

    for i1, v1 in ipairs(t1x) do
        local v1f = v1[list[1].name]
        if i1 > 1 and v1f_previous == v1f  and comp[i1-1] ~= nil  then
            i2 = comp[i1-1][1]
        end
        found = false 

        while t2x[i2] do
            counter = counter + 1
            local v2 = t2x[i2] 
            local v2f = t2x[i2][list[1].name]

            if cfc(v1f, v2f) then
                found = true
                dupe(v1._i, v2._i)
                if not comp[i1] then
                    comp[i1] = {}  
                end
                table.insert(comp[i1], i2)
                i2 = i2 + 1
            elseif v2f > v1f then
                break
            elseif v2f < v1f then
                callback2(v2._i) 
                i2 = i2 + 1 
            end
        end 
        if not found then
            callback(v1._i)
        end

        v1f_previous = v1f
    end

    if callback2~=nil then
        while t2x[i2] do
            callback2(t2x[i2]._i)
            i2 = i2+1  
        end
    end

    return comp , counter
end