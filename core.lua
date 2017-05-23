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