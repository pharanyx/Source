module("ui", package.seeall)


-- Project Source User Interface


-- Set Interface Dynamics

local x, y = getMainWindowSize()
local l = round(x * 0.02)
local t = round(y * 0.04)
local r = round(x * 0.52)
local b = round(y * 0.04)

setBorderLeft(l)
setBorderTop(t)
setBorderRight(0)
setBorderBottom(b)

local f = {
	["3841"] = "24px",
	["2561"] = "18px",
	["1921"] = "16px",
	["1601"] = "10px",
	["1361"] = "9px",
	["801"]  = "8px",
	["641"]  = "7px"
}

local i = 1

for r, p in pairs(f) do
	if l > tonumber(r) then
		i = i + 1
	else
		core.font_size = p
		break
	end
end


default_css = [[
	QLabel{
    	background-color: #232629;
    	padding: 1px;
    	border-style: solid;
    	border: 1px solid #31363b;
    	border-radius: 9px;
    	color: #eff0f1;
	}

	QLabel::hover{
   		background-color: #232629;
   		padding: 1px;
   		border-style: solid;
   		border: 1px solid #3daee9;
   		border-radius: 9px;
   		color: #eff0f1;
	}
]]



-- Container & Label Definitions

containers = {}
labels = {}


-- Draw Containers

containers.main = Geyser.Container:new({
	name = "containers.main",
	x = "0%", y = "0%",
	width = "100%", height = "100%"
})

containers.header = Geyser.Container:new({
	name = "containers.header",
	x = "0%", y = "0%",
	width = "65%", height = "4%"
}, containers.main)

containers.status = Geyser.Container:new({
	name = "containers.status",
	x = "0%", y = "96%",
	width = "65%", height = "4%"
}, containers.main)

containers.chat = Geyser.Container:new({
	name = "containers.chat",
	x = "65%", y = "0%",
	width = "34%", height = "40%"
}, containers.main)

containers.mapper = Geyser.Container:new({
	name = "containers.mapper",
	x = "65%", y = "55%",
	width = "34%", height = "45%"
}, containers.main)


-- Draw Labels

labels.header = Geyser.Label:new({
	name = "labels.header",
	x = "0%", y = "0%",
	width = "100%", height = "100%",
	fgColor = "dark_orchid",
	message = [[
		<p style="font-size: ]] .. core.font_size .. 
		[[; font-family: ']] .. core.ui_font .. 
		[[';"><b><font color="brown">> Project Source v<font color="aquamarine">]] .. core.version ..
		[[ <font color="brown">  |   Name:<font color="aquamarine"> ]] .. "..." .. 
		[[ <font color="brown">  |   City:<font color="aquamarine"> ]] .. "..." .. 
		[[<font color="brown">   |   House:<font color="aquamarine"> ]] .. "..." .. 
		[[</font></p>
	]]
}, containers.header)

labels.status = Geyser.Label:new({
	name = "labels.status",
	x = "0%", y = "0%",
	width = "100%", height = "100%",
	fgColor = "dark_orchid",
	message = [[
		<p style="font-size: ]] .. core.font_size .. 
		[[; font-family: ']] .. core.ui_font .. 
		[[';"><b><font color="brown">* Target:<font color="aquamarine"> ]] .. tmp.target .. 
		[[ <font color="brown">  |  Status:<font color="aquamarine"> ]] .. core.state .. 
		[[ <font color="brown"> |  Experience:<font color="aquamarine"> ]] .. "0" .. 
		[[ <font color="brown"> ]] .. tmp.extra_info .. 
		[[ <font color="brown"> |  Gold:<font color="aquamarine"> ]] .. "0" .. 
		[[ <font color="brown"> |  Bank:<font color="aquamarine"> ]] .. "0" .. 
		[[ <font color="brown"> |  Messages:<font color="aquamarine"> ]] .. "0" .. 
		[[ <font color="brown"> |  Unread News Count:<font color="aquamarine"> ]] .. "0" .. 
		[[ </font></p>
	]]
}, containers.status)


-- Draw Mapper Component

labels.mapper = Geyser.Mapper:new({
	name = "labels.mapper",
	x = "0%", y = "0%", 
	width = "100%", height = "100%"
}, containers.mapper)



-- User Interface Additions

function header(self, title, extra)
    local replen = 55 - (13 + title:len())
    cecho("\n<firebrick>+<aquamarine>----- <firebrick>[<slate_grey> "..title:title().." <firebrick>] "..string.rep("<aquamarine>-", replen).." <firebrick>(<aquamarine> "..getTime(true, "hh:mma - dd/MM/yyyy").." <firebrick>) <aquamarine>-----<firebrick>+\n\n")
end


function footer()
    cecho("\n<firebrick>+<aquamarine>"..string.rep("-", 55).."<firebrick> [<slate_grey> Source-"..core.version.." <firebrick>]<aquamarine> "..string.rep("-", 11).."<firebrick>+\n")
end


-- Colourful Event Echoes

function combat_echo(self, text, colour, width)
	if not text then
		text = tostring(text)
		if not text then
			e:error("Invalid argument #1 to combat_echo(): String expected.")
			return
		end
	end

	gaglp()

	text = string.gsub(text, "%a", "%1 "):sub(1, -2)
	text = "+    +    +    " .. text:upper() .. "    +    +    +"
	
	local width = width or 80
	
	if #text + 4 > width then
		width = #text + 4
	end

	local lindent = math.floor(((width - #text) / 2) - 1)
	local rindent = math.ceil(((width - #text) / 2) - 1)

	local colours = {
		red     = "<black:red>",
		blue    = "<navajo_white:midnight_blue>",
		green   = "<navajo_white:dark_green>",
		yellow  = "<black:gold>",
		purple  = "<navajo_white:DarkViolet>",
		orange  = "<black:dark_orange>",
	}

	local selection = colours[colour] or colours["yellow"]

	cecho("\n" .. selection .. "+" .. string.rep("-", (width - 2)) .. "+")
	cecho("\n" .. selection .. "|" .. string.rep(" ", lindent) .. text .. string.rep(" ", rindent) .. "|")
	cecho("\n" .. selection .. "+" .. string.rep("-", (width - 2)) .. "+")
end


function oecho(self, txt, colour, pleft)
	local colour = colour or "orange"
 	local pleft = pleft or 70
 	local pright = 80 - pleft
 	local left = create_line_gradient(true, pleft - string.len(txt)) .. "[ "
 	local middle = "<" .. colour .. ">" .. txt
 	local right = " |caaaaaa]" .. create_line_gradient(false, pright)
 	hecho("\n" .. left)
 	cecho(middle)
 	hecho(right)
end


function create_ine_gradient(self, left, width)
	local hex = left and "1" or "a"
	local width = width or 10
	local gradient = ""
	local length = 0
     
	while length < width do
		gradient = gradient .. "|c" .. string.rep(hex, 6) .. "-"
		if left and hex == "9" then
			hex = "a"
		elseif left and hex ~= "a" then
			hex = tostring(tonumber(hex) + 1)
		elseif not left and width - length < 10 and hex == "a" then
			hex = "9"
		elseif not left and width - length < 10 and hex ~= "1" then
			hex = tostring(tonumber(hex) - 1)
		end

		length = length + 1
	end
     
	return gradient
end


function event_label(self, text, duration)
	local width, height = getMainWindowSize()
	local strLen = text:len()
	local label = randomstring(8, "%l%d")

	tmp.labels[label] = {label = label, text = text, duration = (duration or 5)}
	createLabel(label, 0, 0, 0, 0, 1)
	setLabelStyleSheet(label, [[
		background-color: qlineargradient(spread:pad, x1:0, y1:2, x2:0, y2:0, stop:0 rgba(184, 206, 250), stop:1 rgba(184, 206, 250));
		border-radius: 16px;
		border-width: 8px;
		border-style: double;
		border-color: rgb(50, 0, 75);
		text-align: center;
	]])
               
	resizeWindow(label, strLen * 25, 70)
	local tabLen, offset = counttable(tmp.labels), 100
	local topPos = (height / 2.0) - (tabLen * 75)
	if topPos > 0 then
		moveWindow(label, (width - (strLen * 25)) / 3, topPos)
	end

	echo(label, [[<p style="font-size:18px; font-family: 'Crushed';"><b><center><font color="brown">]] .. text .. [[</font></center></b></p>]])
        
	if topPos > 0 then
		showWindow(label)
		table.insert(tmp.displayed_labels, label)
	else
		hideWindow(label)
		table.insert(tmp.label_queue, label)
	end

	resetFormat()
end


function event_label_loop()
	if not tmp.labels then return end
	local to_hide = {}
	local need_redraw = false

	for index, label in pairs(tmp.displayed_labels) do
		tmp.labels[label].duration = tmp.labels[label].duration - 0.5
		if tmp.labels[label].duration <= 0 then
			to_hide[label] = true
			need_redraw = true
		end
	end

	for i = 1, #(tmp.displayed_labels) do
		if not tmp.displayed_labels[i] then 
			break 
		end
			
		if to_hide[tmp.displayed_labels[i]] then
			hideWindow(tmp.displayed_labels[i])
			tmp.labels[tmp.displayed_labels[i]] = nil
			table.remove(tmp.displayed_labels, i)
			i = i - 1
		end
	end
        
	local width, height = getMainWindowSize()
	if need_redraw or (#(tmp.displayed_labels) == 0 and #(tmp.label_queue) > 0) then
		local brk = false
		local iter = 1
		while not brk do
			local topPos = (height / 2.0) - ((iter) * 75)
			if tmp.displayed_labels[iter] then
				local label = tmp.displayed_labels[iter]
				moveWindow(label, (width - (#(tmp.labels[label].text) * 25)) / 3, topPos)
			elseif topPos >= 0 and #(tmp.label_queue) > 0 then
				local label = table.remove(tmp.label_queue, 1)
				table.insert(tmp.displayed_labels, label)
				moveWindow(label, (width - (#(tmp.labels[label].text) * 25)) / 3, topPos)
				showWindow(label)
			else
				brk = true
				break;
			end
                        
			iter = iter + 1
		end
	end
end



-- Update Statusbar Loop Timer Function

function update_statusbar()
	if not gmcp.Char then return end
	local out = [[
		<p style="font-size: ]] .. core.font_size .. 
		[[; font-family: ']] .. core.ui_font .. 
		[[';"><b><font color="brown">* Target:<font color="aquamarine"> ]] .. tmp.target .. 
		[[ <font color="brown">  |  Status:<font color="aquamarine"> ]] .. core.state .. 
		[[<font color="brown"> |  Level:<font color="aquamarine"> ]] .. comma_value(gmcp.Char.Status.level) .. 
		[[ <font color="brown"> ]] .. tmp.extra_info .. 
		[[ <font color="brown"> |  Gold:<font color="aquamarine"> ]] .. comma_value(gmcp.Char.Status.gold) .. 
		[[ <font color="brown"> |  Bank:<font color="aquamarine"> ]] .. comma_value(gmcp.Char.Status.bank) .. 
		[[<font color="brown"> |  Messages:<font color="aquamarine"> ]] .. gmcp.Char.Status.unread_msgs .. 
		[[<font color="brown"> |  Unread News Count:<font color="aquamarine"> ]] .. gmcp.Char.Status.unread_news .. 
		[[</font></p>
	]]

	labels.status:echo(out)
end

function update_header()
	if not gmcp.Char then return end
	local out = [[
		<p style="font-size: ]] .. core.font_size .. 
		[[; font-family: ']] .. core.ui_font .. 
		[[';"><b><font color="brown">> Project Source v<font color="aquamarine">]] .. core.version ..
		[[ <font color="brown">  |   Name:<font color="aquamarine"> ]] .. gmcp.Char.Status.name .. 
		[[ <font color="brown">  |   City:<font color="aquamarine"> ]] .. gmcp.Char.Status.city .. 
		[[<font color="brown">   |   Class:<font color="aquamarine"> ]] .. gmcp.Char.Status.class .. 
		[[</font></p>
	]]

	labels.header:echo(out)
end


-- Chat Component

elements = {}
elements.chat = {}
elements.chat.tabsToBlink = {}
elements.chat.config = {}
elements.chat.tabs = {}
elements.chat.windows = {}
elements.chat.config.activeColors = {}
elements.chat.config.inactiveColors = {}


elements.chat.use = true
elements.chat.config.timestamp = "HH:mm:ss"
elements.chat.config.timestampCustomColor = false
elements.chat.config.timestampFG = "red"
elements.chat.config.timestampBG = "blue"
elements.chat.config.location = "topright"
elements.chat.config.channels = {
  "All",
  "City",
  "Guild",
  "Clans",
  "Tells",
  "Combat",
  "Misc",
}

elements.chat.config.Alltab = "All"
elements.chat.config.blink = true
elements.chat.config.blinkTime = 3
elements.chat.config.blinkFromAll = false
elements.chat.config.font_size = 9
elements.chat.config.preserveBackground = false
elements.chat.config.gag = false
elements.chat.config.lines = 15
elements.chat.config.width = 60
elements.chat.config.activeColors = {
  r = 0,
  g = 180,
  b = 0,
}

elements.chat.config.inactiveColors = {
  r = 60,
  g = 60,
  b = 60,
}

elements.chat.config.windowColors = {
  r = 0,
  g = 0,
  b = 0,
}

elements.chat.config.activeTabText = "purple"
elements.chat.config.inactiveTabText = "white"
elements.chat.currentTab = elements.chat.currentTab or elements.chat.config.Alltab or elements.chat.config.channels[1]


function elements.chatSwitch(chat)
  local r = elements.chat.config.inactiveColors.r
  local g = elements.chat.config.inactiveColors.g
  local b = elements.chat.config.inactiveColors.b
  local newr = elements.chat.config.activeColors.r
  local newg = elements.chat.config.activeColors.g
  local newb = elements.chat.config.activeColors.b
  local oldchat = elements.chat.currentTab
  if elements.chat.currentTab ~= chat then
    elements.chat.windows[oldchat]:hide()
    elements.chat.tabs[oldchat]:setColor(r,g,b)
    elements.chat.tabs[oldchat]:setStyleSheet([[
			QLabel{
    background-color: #232629;
    padding: 1px;
    border-style: solid;
    border: 1px solid #76797C;
    border-radius: 9px;
    color: #eff0f1;
			}

			QLabel::hover{
    background-color: #232629;
    padding: 1px;
    border-style: solid;
    border: 1px solid #3daee9;
    border-radius: 2px;
    color: #eff0f1;
			}
		]])
    elements.chat.tabs[oldchat]:echo(oldchat, elements.chat.config.inactiveTabText, "c")
    if elements.chat.config.blink and elements.chat.tabsToBlink[chat] then
      elements.chat.tabsToBlink[chat] = nil
    end
    if elements.chat.config.blink and chat == elements.chat.config.Alltab then
      elements.chat.tabsToBlink = {}
    end
  end
  elements.chat.tabs[chat]:setColor(newr,newg,newb)
  elements.chat.tabs[chat]:setStyleSheet([[
		QLabel{
    background-color: #232629;
    padding: 1px;
    border-style: solid;
    border: 1px solid #76797C;
    border-radius: 9px;
    color: #eff0f1;
		}

		QLabel::hover{
    background-color: #232629;
    padding: 1px;
    border-style: solid;
    border: 1px solid #3daee9;
    border-radius: 9px;
    color: #eff0f1;
		}
	]])
  elements.chat.tabs[chat]:echo(chat, elements.chat.config.activeTabText, "c")
  elements.chat.windows[chat]:show()
  elements.chat.currentTab = chat  
end

function elements.chat:resetUI()
  --elements.chat.container = Geyser.Container:new(elements.chat[elements.chat.config.location](), ui.containers.chat)
	elements.chat.container = Geyser.Container:new({
		font_size = elements.chat.config.font_size,
		--x = string.format("-%sc",elements.chat.config.width + 2),
		x = 0,
		y = 0,
		--width = "-15px",
		width = "100%",
		height = string.format("%ic", elements.chat.config.lines + 2),
	}, containers.chat)
  
  elements.chat.tabBox = Geyser.HBox:new({
    x=0,
    y=0,
    width = "100%",
    height = "10%",
    name = "comms_tabs",
  }, elements.chat.container)

end

function elements.chat:create()
  --reset the UI
  elements.chat:resetUI()
  --Set some variables locally to increase readability
  local r = elements.chat.config.inactiveColors.r
  local g = elements.chat.config.inactiveColors.g
  local b = elements.chat.config.inactiveColors.b
  local winr = elements.chat.config.windowColors.r
  local wing = elements.chat.config.windowColors.g
  local winb = elements.chat.config.windowColors.b

  --iterate the table of channels and create some windows and tabs
  for i,tab in ipairs(elements.chat.config.channels) do
    elements.chat.tabs[tab] = Geyser.Label:new({
      name=string.format("tab%s", tab),
    }, elements.chat.tabBox)
    elements.chat.tabs[tab]:echo(tab, elements.chat.config.inactiveTabText, "c")
    elements.chat.tabs[tab]:setColor(r,g,b)
    elements.chat.tabs[tab]:setStyleSheet([[
			QLabel{
    background-color: #232629;
    padding: 1px;
    border-style: solid;
    border: 1px solid #76797C;
    border-radius: 9px;
    color: #eff0f1;
			}

			QLabel::hover{
    background-color: #232629;
    padding: 1px;
    border-style: solid;
    border: 1px solid #3daee9;
    border-radius: 9px;
    color: #eff0f1;
			}
		]])
    elements.chat.tabs[tab]:setClickCallback("ui.elements.chatSwitch", tab)
    elements.chat.windows[tab] = Geyser.MiniConsole:new({
--      font_size = elements.chat.config.font_size,
      x = 0,
      y = "10%",
      height = "100%",
      width = "100%",
      name = string.format("win%s", tab),
    }, elements.chat.container)
    elements.chat.windows[tab]:setFontSize(elements.chat.config.font_size)
    elements.chat.windows[tab]:setColor(winr,wing,winb)
    elements.chat.windows[tab]:setWrap(elements.chat.config.width)
    elements.chat.windows[tab]:hide()
  end
  local showme = elements.chat.config.Alltab or elements.chat.config.channels[1]
  elements.chatSwitch(showme)
  --start the blink timers, if enabled
  if elements.chat.config.blink and not elements.chat.blinkTimerOn then
    elements.chat:blink()
  end
end

function elements.chat:append(chat)
  local r = elements.chat.config.windowColors.r
  local g = elements.chat.config.windowColors.g
  local b = elements.chat.config.windowColors.b
  selectCurrentLine()
  local ofr,ofg,ofb = getFgColor()
  local obr,obg,obb = getBgColor()
  if elements.chat.config.preserveBackground then
    setBgColor(r,g,b)
  end
  copy()
  if elements.chat.config.timestamp then
    local timestamp = getTime(true, elements.chat.config.timestamp)
    local tsfg = {}
    local tsbg = {}
    local colorLeader = ""
    if elements.chat.config.timestampCustomColor then
      if type(elements.chat.config.timestampFG) == "string" then
        tsfg = color_table[elements.chat.config.timestampFG]
      else
        tsfg = elements.chat.config.timestampFG
      end
      if type(elements.chat.config.timestampBG) == "string" then
        tsbg = color_table[elements.chat.config.timestampBG]
      else
        tsbg = elements.chat.config.timestampBG
      end
      colorLeader = string.format("<%s,%s,%s:%s,%s,%s>",tsfg[1],tsfg[2],tsfg[3],tsbg[1],tsbg[2],tsbg[3])
    else
      colorLeader = string.format("<%s,%s,%s:%s,%s,%s>",ofr,ofg,ofb,obr,obg,obb)
    end
    local fullstamp = string.format("%s%s",colorLeader,timestamp)
      elements.chat.windows[chat]:decho(fullstamp)
      elements.chat.windows[chat]:echo(" ")
      if elements.chat.config.Alltab then 
        elements.chat.windows[elements.chat.config.Alltab]:decho(fullstamp)
        elements.chat.windows[elements.chat.config.Alltab]:echo(" ")
      end
  end
  elements.chat.windows[chat]:append()
  if elements.chat.config.gag then 
    deleteLine() 
    tempLineTrigger(1,1, [[if isPrompt() then deleteLine() end]])
  end
  if elements.chat.config.Alltab then appendBuffer(string.format("win%s", elements.chat.config.Alltab)) end
  if elements.chat.config.blink and chat ~= elements.chat.currentTab then 
    if (elements.chat.config.Alltab == elements.chat.currentTab) and not elements.chat.config.blinkOnAll then
      return
    else
      elements.chat.tabsToBlink[chat] = true
    end
  end
end



function elements.chat:blink()
  if elements.chat.blinkID then killTimer(elements.chat.blinkID) end
  if not elements.chat.config.blink then 
    elements.chat.blinkTimerOn = false
    return 
  end
  for tab,_ in pairs(elements.chat.tabsToBlink) do
    elements.chat.tabs[tab]:flash()
  end
  elements.chat.blinkID = tempTimer(elements.chat.config.blinkTime, function () elements.chat:blink() end)
end

function elements.chat:topright()
  return {
    font_size = elements.chat.config.font_size,
    x=string.format("-%sc",elements.chat.config.width + 2),
    y=0,
    width="-15px",
    height=string.format("%ic", elements.chat.config.lines + 2),
  }
end

function elements.chat:topleft()
  return {
    font_size = elements.chat.config.font_size,
    x=0,
    y=0,
    width=string.format("%sc",elements.chat.config.width),
    height=string.format("%ic", elements.chat.config.lines + 2),
  }
end

function elements.chat:bottomright()
  return {
    font_size = elements.chat.config.font_size,
    x=string.format("-%sc",elements.chat.config.width + 2),
    y=string.format("-%sc",elements.chat.config.lines + 2),
    width="-15px",
    height=string.format("%ic", elements.chat.config.lines + 2),
  }
end

function elements.chat:bottomleft()
  return {
    font_size = elements.chat.config.font_size,
    x=0,
    y=string.format("-%sc",elements.chat.config.lines + 2),
    width=string.format("%sc",elements.chat.config.width),
    height=string.format("%ic", elements.chat.config.lines + 2),
  }
end


function elements.chat:cecho(chat, message)
  local alltab = elements.chat.config.Alltab
  local blink = elements.chat.config.blink
  cecho(string.format("win%s",chat), message)
  if alltab and chat ~= alltab then 
    cecho(string.format("win%s", alltab), message)
  end
  if blink and chat ~= elements.chat.currentTab then
    if (alltab == elements.chat.currentTab) and not elements.chat.config.blinkOnAll then
      return
    else
      elements.chat.tabsToBlink[chat] = true
    end
  end
end

function elements.chat:decho(chat, message)
  local alltab = elements.chat.config.Alltab
  local blink = elements.chat.config.blink
  decho(string.format("win%s",chat), message)
  if alltab and chat ~= alltab then 
    decho(string.format("win%s", alltab), message)
  end
  if blink and chat ~= elements.chat.currentTab then
    if (alltab == elements.chat.currentTab) and not elements.chat.config.blinkOnAll then
      return
    else
      elements.chat.tabsToBlink[chat] = true
    end
  end
end

function elements.chat:hecho(chat, message)
  local alltab = elements.chat.config.Alltab
  local blink = elements.chat.config.blink
  hecho(string.format("win%s",chat), message)
  if alltab and chat ~= alltab then 
    hecho(string.format("win%s", alltab), message)
  end
  if blink and chat ~= elements.chat.currentTab then
    if (alltab == elements.chat.currentTab) and not elements.chat.config.blinkOnAll then
      return
    else
      elements.chat.tabsToBlink[chat] = true
    end
  end
end

function elements.chat:echo(chat, message)
  local alltab = elements.chat.config.Alltab
  local blink = elements.chat.config.blink
  echo(string.format("win%s",chat), message)
  if alltab and chat ~= alltab then 
    echo(string.format("win%s", alltab), message)
  end
  if blink and chat ~= elements.chat.currentTab then
    if (alltab == elements.chat.currentTab) and not elements.chat.config.blinkOnAll then
      return
    else
      elements.chat.tabsToBlink[chat] = true
    end
  end
end


elements.chat:create()