--[[ detect-monitors.lua
This is the magical service that listens to udev events for detecting monitors, then 
automatically configures them and stores the configuration on the local machine via autorandr.

If LxQt can do it, Lycan can do it.
]]


local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local DetectMonitor = {}
DetectMonitor.__index = DetectMonitor

function DetectMonitor.new()
    return setmetatable({}, DetectMonitor)
end

function DetectMonitor.setup_screens()
    awful.spawn.easy_async_with_shell("xrandr -q", function(stdout, stderr, exitreason, exitcode)
        if exitcode ~= 0 then
            naughty.notify({ title = "Error Querying xrandr", text = stderr, preset = naughty.config.presets.critical })
            return
        end
        
        local connected_screens = {}
        for line in stdout:gmatch("[^\r\n]+") do
            local screen_name = line:match("^(.-) connected")
            if screen_name then
                connected_screens[#connected_screens + 1] = {name=screen_name, xrandr_output=line}
            end
        end
        
        for _, screen_info in ipairs(connected_screens) do
            local max_res = screen_info.xrandr_output:match(" (%d+x%d+) %s+%d+.%d%d?%*?")
            if max_res then
                awful.spawn.easy_async_with_shell("xrandr --output " .. screen_info.name .. " --mode " .. max_res, function()
                    awful.spawn.easy_async_with_shell("autorandr --save " .. screen_info.name, function()
                        naughty.notify({ title = "Monitor Configuration", text = "Applied and saved configuration for " .. screen_info.name })
                    end)
                end)
            else
                awful.spawn.easy_async_with_shell("autorandr --change", function()
                    naughty.notify({ title = "Monitor Configuration", text = "Maximum resolution could not be determined for " .. screen_info.name .. ". Applied autorandr --change." })
                end)
            end
        end
    end)
end


local debounce_timer = nil
local debounce_time = 2 -- in seconds

awful.spawn.with_line_callback("stdbuf -oL udevadm monitor --property --subsystem-match=drm", {
    stdout = function(line)
        if line:match("ACTION=change") then
            if debounce_timer then
                debounce_timer:stop()
                debounce_timer = nil
            end

            debounce_timer = gears.timer.start_new(debounce_time, function()
                DetectMonitor.setup_screens()
            end)
        end
    end,
    stderr = function(line)
        naughty.notify({ title = "Monitor Error", text = line, preset = naughty.config.presets.critical })
    end
})

return DetectMonitor

