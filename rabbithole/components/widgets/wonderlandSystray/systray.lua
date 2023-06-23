local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local systrayContainer = wibox.widget {
    {
        {
            wibox.widget.systray(),
            margins = dpi(1.5),
            widget = wibox.container.margin,
        },
        shape = gears.shape.rounded_rect, 
        shape_clip = true,
        widget = wibox.container.background,
        bg = beautiful.neutral,
    },
    margins = dpi(4),
    widget = wibox.container.margin
}

return systrayContainer
