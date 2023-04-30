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
    -- Takes a screenshot on left mouse click, and  screen record on right click
    local buttons = awful.util.table.join(
        awful.button({}, 1, function()
            self:takeScreenshot()
        end),
        awful.button({}, 3, function()
            self:startScreenRecording()
        end)
    )
    return buttons
end

function screenCapture:takeScreenshot()
    -- You can use scrot or flameshot, whichever is your preference
    --local command = "flameshot gui"
    --awful.spawn.easy_async_with_shell(command, function()
    local cursor_flag = include_cursor and "-cursor" or ""
    local command = "sleep 0.5 && scrot " .. cursor_flag .. " '%Y-%m-%d_%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/Screenshots/'"
    awful.spawn.easy_async_with_shell(command, function()
        -- callbacks
    end)
end

function screenCapture:startScreenRecording()
    local command = "ffmpeg -f x11grab -r 30 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 -c:v libx264 -preset ultrafast -crf 0 -threads 0 ~/Videos/screen_record-$(date '+%Y-%m-%d_%H-%M-%S').mkv"
    awful.spawn.easy_async_with_shell(command, function()
        -- callbacks
    end)
end

return screenCapture