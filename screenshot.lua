local awful = require("awful")
local naughty = require("naughty")

-- you can change this to your screenshot directory
local base_path = os.getenv("HOME") .. "/Pictures/Screenshots/"

local function get_filename()
	return os.date("%Y-%m-%dT%H-%M-%S")
end

function screenshot_full()
	local path = base_path .. get_filename() .. ".png"
	screenshot(path)

	callback("Made screenshot of all screen(s)\nPath: " .. path, 5)
end

function screenshot_active_window()
	local path = base_path .. get_filename() .. ".png"
	screenshot(path, "-i $(xdotool getactivewindow)")

	callback("Made screenshot of active window\nPath: " .. path, 5)
end

function screenshot_selection()
	local path = base_path .. get_filename() .. ".png"
	screenshot(path, "-s")

	callback("Made screenshot of selected region\nPath: " .. path, 5)
end


function screenshot(path, ...)
	args = ""
	-- add supplied args
	for k, v in ipairs({...}) do
		args = args .. v .. " "
	end

	command = "maim " .. args .. path .. " && xclip -selection clipboard -t image/png " .. path

	-- override default user's shell
	awful.util.shell = "/bin/bash"
	
	awful.spawn.with_shell(command)
end

function callback(text, timeout)
    naughty.notify({
        text = text,
        timeout = timeout
    })
end
