local wibox = require('wibox')

local Clock = {}

local ClockWidget = wibox.widget.textclock('<span font="10">%H:%M</span>', 1)

Clock.widget = wibox.container.margin(ClockWidget, 10, 10, 10, 10)

return Clock
