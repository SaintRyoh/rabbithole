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
    awful.spawn.easy_async_with_shell("xrandr -q | awk '/ connected/{print $0; getline; print}'", function(stdout)
        local screens = gears.string.split(stdout, "\n")
        for i = 1, #screens, 2 do
            local line = screens[i]
            local screen_name = line:match("^(.-) connected")
            if screen_name then
                local max_res = screens[i + 1]:match("(%d+x%d+)") 
                if max_res then
                    awful.spawn.easy_async_with_shell("xrandr --output " .. screen_name .. " --mode " .. max_res, function()
                        awful.spawn.easy_async_with_shell("autorandr --save " .. screen_name, function()
                            naughty.notify({ title = "Automatic Display Configuration", text = "Applied and saved configuration for " .. screen_name })
                        end)
                    end)
                else  
                    awful.spawn.easy_async_with_shell("autorandr --change", function()
                        naughty.notify({ title = "Automatic Display Configuration", text = "Maximum resolution could not be determined for " .. screen_name .. ". Autodetected settings applied." })
                    end)
                end
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