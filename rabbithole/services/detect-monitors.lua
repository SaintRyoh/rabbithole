local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local DetectMonitor = {}
DetectMonitor.__index = DetectMonitor

function DetectMonitor.new()
    return setmetatable({}, DetectMonitor)
end

function DetectMonitor.setup_screens()
    -- Query connected screens
    awful.spawn.easy_async_with_shell("xrandr -q | grep ' connected'", function(stdout)
        local screens = gears.string.split(stdout, "\n")
        for _, line in pairs(screens) do
            local screen_name = line:match("^(.-) connected")
            if screen_name then
                -- Find and set the highest available resolution for the connected screen
                local max_res = line:match("%d+x%d+")
                awful.spawn.easy_async_with_shell("xrandr --output " .. screen_name .. " --mode " .. max_res, function()
                    -- Save the configuration using autorandr
                    awful.spawn.easy_async_with_shell("autorandr --save " .. screen_name, function()
                        naughty.notify({ title = "Monitor Configuration", text = "Applied and saved configuration for " .. screen_name })
                    end)
                end)
            end
        end
    end)
end

-- Listen to udev events for monitor changes
awful.spawn.with_line_callback("stdbuf -oL udevadm monitor --property --subsystem-match=drm", {
    stdout = function(line)
        -- Check for the CHANGE event related to display connection/disconnection
        if line:match("ACTION=change") then
            DetectMonitor.setup_screens()
        end
    end,
    stderr = function(line)
        naughty.notify({ title = "Monitor Error", text = line, preset = naughty.config.presets.critical })
    end
})

return DetectMonitor
