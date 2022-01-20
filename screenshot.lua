local awful = require("awful")
local naughty = require("naughty")

timers = { 5,10 }

function scrot_full()
	local screenshot = "\"/home/zakhar/Pictures/scrot/" .. os.time() .. ".png\""
    scrot("scrot " .. screenshot, scrot_callback, "Take a screenshot of entire screen\n" .. screenshot)
	copy_screenshot(screenshot)
end

function scrot_selection()
	local screenshot = "\"/home/zakhar/Pictures/scrot/" .. os.time() .. ".png\""
    scrot("sleep 0.5 && scrot -s " .. screenshot, scrot_callback, "Take a screenshot of selection")
    copy_screenshot(screenshot)
end

function scrot_window()
	local screenshot = "\"/home/zakhar/Pictures/scrot/" .. os.time() .. ".png\""
    scrot("scrot -u " .. screenshot, scrot_callback, "Take a screenshot of focused window")    
    copy_screenshot(screenshot)
end

function scrot_delay()
    items={}
    for key, value in ipairs(timers)  do
        items[#items+1]={tostring(value) , "scrot -d ".. value.." " .. screenshot, "Take a screenshot of delay" }
    end
    awful.menu.new(
    {
        items = items
    }
    ):show({keygrabber= true})
    scrot_callback()
end

function scrot(cmd , callback, args)
    awful.util.spawn(cmd)
    callback(args)
end

function copy_screenshot(path)
	local command = "fish -c xclip -selection clipboard -t image/png -i " .. path
	scrot_callback(command)

	local results = {awful.spawn.spawn(command)}

	local toPrint = ""

	for k, v in pairs(results) do
		toPrint = toPrint .. tostring(v) .. "\n"
	end

	scrot_callback(toPrint)
end

function scrot_callback(text)
    naughty.notify({
        text = text,
        timeout = 20
    })
end
