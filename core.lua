module("core", package.seeall)


-- Jagged Core System Functions


-- Core System Variables

font_size = "12px"
realm = "Aetolia"
state = "Active"
ui_font = "Hack"
version = "0.9.1"

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

function send_prio(self, command, priority)
	prio = priority or 100
	jfm.echo("Added '" .. command:upper() .. "' with a priority of: " .. prio..".")
	queue:push(command, prio)
end

function prompt()
	raiseEvent("act")
	while not queue:isempty() do
		local command = queue:pop()
		send(command)
	end
end

registerAnonymousEventHandler("prompt_received", "core.prompt")