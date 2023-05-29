local wibox = require('wibox')
local gears = require('gears')

local clock = {}

local clock_widget = wibox.widget.textclock('<span font="10">%H:%M</span>', 1)

clock.widget = wibox.container.margin(clock_widget, 10, 10, 10, 10)

return clock
