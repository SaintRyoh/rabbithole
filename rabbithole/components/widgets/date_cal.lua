local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local screen = awful.screen.focused()

local DateWidget = {}

DateWidget.widget = wibox.widget.textclock('<span font="8">%a %b %d, %Y</span>', 60)

local calendar_widget = awful.widget.calendar_popup.month({
    start_sunday = true,
    week_numbers = true,
    long_weekdays = true,
})

calendar_widget:attach(DateWidget.widget, "tr", { on_hover = true })

-- Override the placement method
calendar_widget.placement_fn = function(w)
    awful.placement.top_right(w, { margins = { top = dpi(34) }, parent = screen })
end

return DateWidget
