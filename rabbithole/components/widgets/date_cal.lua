local awful = require("awful")
local wibox = require("wibox")

local DateWidget = {}

DateWidget.widget = wibox.widget.textclock('<span font="10">%a %b %d, %Y</span>', 60)

local calendar_widget = awful.widget.calendar_popup.month({
    start_sunday = true,
    week_numbers = true,
    long_weekdays = true,
})

DateWidget.widget:connect_signal('mouse::enter', function () calendar_widget:toggle() end)
DateWidget.widget:connect_signal('mouse::leave', function () calendar_widget:toggle() end)

return DateWidget
