module("log", package.seeall)


-- Project Source HTML5 logging functionality


function recordcurrentline()
  local line_num, cur_line = getLineNumber(), getCurrentLine()

  local output, tc = {}, 1
  local index = 0
  local r,g,b = 0,0,0
  local br,bg,bb = 0,0,0
  local cbr,cbg,cbb --last bg colors
  local cr,cg,cb -- last colors
  local tc = 1 -- table count

  while index < #cur_line do
    index = index + 1

    if moveCursor("main", index, line_num) and selectString(cur_line:sub(index), 1) then
      r,g,b = getFgColor()
      br,bg,bb = getBgColor()
      if cr ~= r or cg ~= g or cb ~= b or cbr ~= br or cbg ~= bg or cbb ~= bb then
        cr,cg,cb = r,g,b
        cbr,cbg,cbb = br,bg,bb
        if tc == 1 then
          output[tc] = string.format("<span style=\'color: rgb(%d,%d,%d);background: rgb(%d,%d,%d);'>%s", r,g,b,br,bg,bb, cur_line:sub(index, index))
        else
          output[tc] = string.format("</span><span style=\'color: rgb(%d,%d,%d);background: rgb(%d,%d,%d);'>%s", r,g,b,br,bg,bb, cur_line:sub(index, index))
        end
        tc = tc +1
      else
        output[tc] = cur_line:sub(index, index)
        tc = tc +1
      end
      cur_line:sub(index, index)
    end
  end
  output[#output+1] = "</span>"

  return table.concat(output)
end

function stop()
  disableTrigger("Capture each line")
  disableTrigger("Record on the prompt")

  current_data[#current_data+1] = [[</div>
</body>
</html>]]


  local logfile = getMudletHomeDir().."/"..os.date.."-log.html"
  local file_output = io.open(logfile, "w")


  local conversions = {
    ["Â¦"] = "&brvbar;",
    ["Ã—"] = "&times;",
    ["Â«"] = "&#171;",
    ["Â»"] = "&raquo;"
  }


  local s = table.concat(current_data)

  for from, to in pairs(conversions) do
    s = string.gsub(s, from, to)
  end

  file_output:write(s)
  file_output:close()

  -- this can use quite a bit of memory on a large buffer, so free it up right away
  collectgarbage("collect")
  local location = [[file:///]]..logfile:gsub([[\]], "/")
  cecho("\n<cyan>Log recording finished, opening <cyan>"..location..".")
  openUrl(location)

  current_data = nil
  inbetween = nil
  if trig then killTrigger(trig) end
  trig = nil

  label:hide()
  collectgarbage("collect")
end

function showlabel()
  if label then
    label:show()
  else

    label = Geyser.Label:new({
      name="label",
      x=-110, y=-60,
      width=50, height=30,
    })

    label:setStyleSheet[[
      color: #333;
      border: 2px solid #555;
      border-radius: 11px;
      padding: 5px;
      background: qradialgradient(cx: 0.3, cy: -0.4,
      fx: 0.3, fy: -0.4,
      radius: 1.35, stop: 0 #fff, stop: 1 #888);
      min-width: 80px;
  ]]

    label:echo"<center>Stop logging</center>"
    label:setClickCallback("log.stop")
  end
end

function recordline()
  inbetween[#inbetween+1] = recordcurrentline()

  if isPrompt() then
    for i = 1, #inbetween do
      current_data[#current_data+1] = string.format([[<div id="%d" class="log tnc_default"><p>%s</p></div>]], getStopWatchTime(recording_stopwatch)*1000, string.gsub(inbetween[i], '\n', '<br/>'))
    end

    inbetween = {}
  end
end


function dolog()
  recording_stopwatch = createStopWatch()
startStopWatch(recording_stopwatch)

current_data = {[[

<html>
    <head>
    <style>
            /* http://meyerweb.com/eric/tools/css/reset/
               v2.0 | 20110126
               License: none (public domain)
            */
            html, body, div, span, applet, object, iframe,
            h1, h2, h3, h4, h5, h6, p, blockquote, pre,
            a, abbr, acronym, address, big, cite, code,
            del, dfn, em, img, ins, kbd, q, s, samp,
            small, strike, strong, sub, sup, tt, var,
            b, u, i, center,
            dl, dt, dd, ol, ul, li,
            fieldset, form, label, legend,
            table, caption, tbody, tfoot, thead, tr, th, td,
            article, aside, canvas, details, embed,
            figure, figcaption, footer, header, hgroup,
            menu, nav, output, ruby, section, summary,
            time, mark, audio, video {
                    margin: 0;
                    padding: 0;
                    border: 0;
                    font-size: 100%;
                    font: inherit;
                    vertical-align: baseline;
            }
            /* HTML5 display-role reset for older browsers */
            article, aside, details, figcaption, figure,
            footer, header, hgroup, menu, nav, section {
                    display: block;
            }
            body {
                    line-height: 1;
            }
            ol, ul {
                    list-style: none;
            }
            blockquote, q {
                    quotes: none;
            }
            blockquote:before, blockquote:after,
            q:before, q:after {
                    content: '';
                    content: none;
            }
            table {
                    border-collapse: collapse;
                    border-spacing: 0;
            }
            html, body {
                    background: #000;
                    color: silver;
                    margin: 10px;
                    font-size: 13px;
                    font-family: 'Arial',sans-serif;
            }
            p, h2, pre {
                    padding: 1px;
                    margin: -1px;
                    clear: both;
            }
            A:link, A:visited, A:active {
                    color: #327CE3;
                    text-decoration: none;
            }
            A:hover {
                    color: #fff;
            }
            h1 {
                    font-size: 30px;
                    margin: 0;
                    padding: 0;
            }
            h2 {color: #327CE3;}
            td {vertical-align: top;}
            .clear {clear: both; height: 5px;}
            .break {line-height: 100%; margin: 0; padding:0px; padding: 1px 0;}
            .tnc_bg_default {background: #111;}
            .tnc_default {color: silver;}
            .tnc_bright .tnc_default {color: #fff;}
            .tnc_normal {font-weight:normal;}
            .tnc_bold {font-weight: bold;}
            .tnc_inverse {color: black; background: white;}
            .tnc_black {color: black;}
            .tnc_red {color: #800000;}
            .tnc_green {color: #00b300;}
            .tnc_yellow {color: #808000;}
            .tnc_blue {color: #000080;}
            .tnc_magenta {color: #800080;}
            .tnc_cyan {color: #008080;}
            .tnc_white {color: silver;}
            .tnc_bright .tnc_black {color: #464646;}
            .tnc_bright .tnc_red {color: #ff0000;}
            .tnc_bright .tnc_green {color: #00ff00;}
            .tnc_bright .tnc_yellow {color: #ffff00;}
            .tnc_bright .tnc_blue {color: #0000ff;}
            .tnc_bright .tnc_magenta {color: #ff00ff;}
            .tnc_bright .tnc_cyan {color: #00ffff;}
            .tnc_bright .tnc_white {color: white;}
            .tnc_bg_black {background-color: black;}
            .tnc_bg_red {background-color: #800000;}
            .tnc_bg_green {background-color: #00b300;}
            .tnc_bg_yellow {background-color: #808000;}
            .tnc_bg_blue {background-color: #000080;}
            .tnc_bg_magenta {background-color: #ff00ff;}
            .tnc_bg_cyan {background-color: #008080;}
            .tnc_bg_white {background-color: silver;}
            #options {
                position:fixed;
                top:0;
                left: 0;
                background: #242424;
                border-bottom: 1px solid #464646;
                width: 100%;
                height: 50px;
            }
            #current_time, #save {
                float:right;
                min-width: 150px;
                height: 25px;
                background: #000;
                border: 1px solid #464646;
                margin: 5px;
                padding: 5px;
                padding-top: 10px;
                font-size: 24px;
                text-align: center;
            }
            #buttons {
                margin-left: 10px;
                margin-top: 15px;
            }
            #log {
                padding-top: 55px;
                word-wrap: break-word;
                white-space: pre-wrap;
                font-family: monospace;
            }
            #log p {
              padding: 0px;
              margin: 0px;
              line-height: 120%;
              clear: both;
         }
    </style>
    </head>
    <body>
<script type="text/javascript">
    var log;
    var first_offset = 0;
    var last_index = 0;
    var timer;
    var display_time = function () {
        document.getElementById("current_time").style.color = "white";
        document.getElementById("current_time").innerHTML = parseFloat(log[last_index].offset/1000) + " sec.";
    }
    var pause = function() {
        clearTimeout(timer);
        display_time();
        document.getElementById("current_time").style.color = "red";
    }
    var rewind = function (time)
    {
        current_time = parseInt(log[last_index].offset);
        var target_time = current_time - time;
        var target_index = -1;
        for (var i=0; i<last_index; i++)
        {
            if (parseInt(log[i].offset) <= target_time)
            {
                target_index = i;
            }
        }
        if (target_index == -1)
            target_index = log.length - 1;
        for (var j=target_index; j<log.length; j++)
        {
            remove_segment(j);
        }
        last_index = target_index;
        if (last_index < 0)
            last_index = 0;
        pause();
    }
    var fast_forward = function (time) {
        current_time = parseInt(log[last_index].offset);
        var target_time = current_time + time;
        var target_index = -1;
        for (var i=last_index; i<log.length; i++)
        {
            if (parseInt(log[i].offset) <= target_time)
            {
                target_index = i;
            }
        }
        if (target_index == -1)
            target_index = log.length - 1;
        for (var j=last_index; j<=target_index; j++)
        {
            display_segment(j);
            last_index = j;
        }
        last_index++;
        if (last_index >= log.length)
            last_index = 0;
        pause();
    };
    var replay = function () {
        if (last_index == 0)
            document.getElementById("log").innerHTML = "";
        display_time();
        display_segment(last_index);
        if (last_index < log.length)
            timer = setTimeout("replay()", (log[last_index].offset-log[last_index-1].offset));
        else
            last_index = 0;
    };
    var remove_segment = function (i, no_scroll) {
        var elem = document.getElementById(log[i].offset);
        if (elem)
            elem.parentNode.removeChild(elem);
        if (!no_scroll || no_scroll !== true)
            window.scrollTo(0, document.body.scrollHeight);
    };
    var display_segment = function (i, no_scroll) {
        var elem = document.createElement("div");
        elem.setAttribute("id", log[i].offset);
        elem.innerHTML = "<div>";
        offset = log[i].offset;
        while (i < log.length && log[i].offset == offset)
        {
            elem.innerHTML += "<div>" + log[i].message + "</div>";
            i++;
        }
        last_index = i;
        elem.innerHTML += "</div>";
        document.getElementById("log").appendChild(elem);
        if (!no_scroll || no_scroll !== true)
            window.scrollTo(0, document.body.scrollHeight);
    };
    var build_log_array = function ()
    {
        log = [];
        var elems = getElementsByClassName(document, "log");
        for (i in elems)
        {
    if (log[log.length-1] && log[log.length-1].offset == elems[i].getAttribute("id"))
    {
      log[log.length-1].message += elems[i].innerHTML;
    } else {
      log[log.length] = {offset : elems[i].getAttribute("id"), message: "<div>" + elems[i].innerHTML + "</div>"};
    }
        }
        first_offset = log[0].offset;
    }
    var display_all = function () {
        setTimeout(function () {
            for (var i = 0; i < log.length; i++)
                display_segment(i, true);
        }, 0);
    }
    function add_event(obj, evType, fn){
     if (obj.addEventListener){
       obj.addEventListener(evType, fn, false);
       return true;
     } else if (obj.attachEvent){
       var r = obj.attachEvent("on"+evType, fn);
       return r;
     } else {
       return false;
     }
    }
    function getElementsByClassName(node,classname) {
      if (node.getElementsByClassName) { // use native implementation if available
        return node.getElementsByClassName(classname);
      } else {
        return (function getElementsByClass(searchClass,node) {
            if ( node == null )
              node = document;
            var classElements = [],
                els = node.getElementsByTagName("*"),
                elsLen = els.length,
                pattern = new RegExp("(^|\s)"+searchClass+"(\s|$)"), i, j;
            for (i = 0, j = 0; i < elsLen; i++) {
              if ( pattern.test(els[i].className) ) {
                  classElements[j] = els[i];
                  j++;
              }
            }
            return classElements;
        })(classname, node);
      }
    }
    add_event(window, "load", function () {build_log_array()});
</script>
<div id="options">
    <div id="current_time"></div>
    <div id="buttons">
        <input type="button" onclick="replay()" value="Play Log" />
        <input type="button" onclick="pause()" value="Pause"/>
        <input type="button" onclick="rewind(10000)" value="<<" title="Rewind 10 Seconds"/>
        <input type="button" onclick="rewind(5000)" value="<" title="Rewind 5 Seconds"/>
        <input type="button" onclick="fast_forward(5000)" value=">" title="Fast Forward 5 Seconds"/>
        <input type="button" onclick="fast_forward(10000)" value=">>" title="Fast Forward 10 Seconds"/>
        <p id="save">Press <strong>CTRL-S</strong> to save the log on your computer</p>
    </div>
</div>
<div id="log" class="tnc_default">
]]}

inbetween = {}

--enableTrigger("Capture each line")
--enableTrigger("Record on the prompt")

if trig then killTrigger(trig) end
trig = tempRegexTrigger("^", "log.recordline()")

showlabel()
cecho("\nStarted logging... use 'stoplog' to stop.")
end