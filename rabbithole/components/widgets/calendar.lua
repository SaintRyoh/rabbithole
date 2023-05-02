local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")

local calendarWidget = {}


function calendarWidget.new(args)
    local self = {}
    setmetatable(self, { __index = calendarWidget })

    self.widget = self:createWidget(args)

    self.widget:connect_signal("mouse::enter", function()
        self:showCalendarPopup()
    end)

    self.widget:connect_signal("mouse::leave", function()
        self:hideCalendarPopup()
    end)

    return self
end

function calendarWidget:createWidget(args)
    local widget = wibox.widget.textclock("%a, %b %d")

    -- Set appearance from beautiful
    widget.font = beautiful.calendar_font or "sans 12"
    widget.align = "center"
    widget.valign = "center"
    widget.markup = widget.text

    return widget
end

function calendarWidget:showCalendarPopup()
    if not self.calendarPopup then
        self.calendarPopup = awful.widget.calendar_popup.month({
            font = beautiful.calendar_popup_font or "sans 12",
            spacing = beautiful.calendar_popup_spacing or 10,
            week_numbers = true,
            long_weekdays = true,
            margin = 5,
            style_month = {border_width = 0, padding = 5, shape = gears.shape.rounded_rect},
            style_header = {border_width = 0, bg_color = beautiful.bg_focus, shape = gears.shape.rounded_rect},
            style_weekday = {border_width = 0, fg_color = beautiful.fg_normal},
            style_normal = {border_width = 0, fg_color = beautiful.fg_normal},
            style_focus = {border_width = 0, fg_color = beautiful.fg_focus, bg_color = beautiful.bg_focus, shape = gears.shape.rounded_rect}
        })
    end
    self.calendarPopup:call_calendar(0, self.widget, "tr")
end

function calendarWidget:hideCalendarPopup()
    if self.calendarPopup then
        self.calendarPopup.visible = false
    end
end

return calendarWidget
