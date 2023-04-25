local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local screenCapture = {}


function screenCapture.new(args)
    local self = {}
    setmetatable(self, { __index = screenCapture })

    self.widget = self:createWidget(args)
    self.widget:buttons(self:getButtons())

    return self
end

function screenCapture:createWidget(args)
    local widget = wibox.widget.imagebox()
    widget.image = beautiful.screen_capture_icon or "/path/to/your/screen_capture_icon.svg"
    widget.resize = false
    return widget
end

function screenCapture:getButtons()
    local buttons = awful.util.table.join(
        awful.button({}, 1, function()
            self:takeScreenshot(false)
        end),
        awful.button({}, 3, function()
            self:takeScreenshot(true)
        end)
    )
    return buttons
end

function screenCapture:takeScreenshot(include_cursor)
    -- I chose to use scrot, we should bind this to flameshot for both screen shots and screen recording and just add it as a dependency
    local cursor_flag = include_cursor and "-cursor" or ""
    local command = "sleep 0.5 && scrot " .. cursor_flag .. " '%Y-%m-%d_%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/Screenshots/'"
    awful.spawn.easy_async_with_shell(command, function()
        -- You can add a callback function here if needed
    end)
end

return screenCapture
