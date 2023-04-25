local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local systray = require("wonderland.systrayWidget")

local clockWidget = {}

function clockWidget.new(args)
    local self = {}
    setmetatable(self, { __index = clockWidget })

    -- Initialize your clock widget here
    self.widget = self:createWidget(args)

    self.widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            self:toggleSystrayPopup()
        end)
    ))

    return self
end

function clockWidget:createWidget(args)
    local widget = wibox.widget.textclock()

    -- Set appearance from beautiful
    widget.font = beautiful.clock_font or "sans 12"
    widget.align = "center"
    widget.valign = "center"
    widget.markup = widget.text

    return widget
end

function clockWidget:toggleSystrayPopup()
    if not self.systrayPopup then
        self.systrayPopup = systrayWidget.new()
        self.systrayPopup.visible = false
    end

    if self.systrayPopup.visible then
        self.systrayPopup.visible = false
    else
        self.systrayPopup:move_next_to(self.widget)
        self.systrayPopup.visible = true
    end
end

return clockWidget
