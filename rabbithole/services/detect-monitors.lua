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
    awful.spawn.easy_async_with_shell("xrandr -q | grep ' connected'", function(stdout)
        local screens = gears.string.split(stdout, "\n")
        for _, line in pairs(screens) do
            local screen_name = line:match("^(.-) connected")
            if screen_name then
                -- finds and sets the highest available resolution for the connected screen
                local max_res = line:match("%d+x%d+")
                awful.spawn.easy_async_with_shell("xrandr --output " .. screen_name .. " --mode " .. max_res, function()
                    -- save the screen config w/ autorandr
                    awful.spawn.easy_async_with_shell("autorandr --save " .. screen_name, function()
                        naughty.notify({ title = "Monitor Configuration", text = "Applied and saved configuration for " .. screen_name })
                    end)
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
