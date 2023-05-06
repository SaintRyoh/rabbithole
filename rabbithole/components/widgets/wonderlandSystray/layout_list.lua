local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local layoutlist_widget = {}

function layoutlist_widget.new(s)
    local layout = wibox.widget {
        {
            {
                awful.widget.layoutbox(s),
                id = "icon_layout",
                widget = wibox.container.place
            },
            id = "icon_margin",
            left = dpi(5),
            right = dpi(5),
            top = dpi(5),
            bottom = dpi(5),
            forced_width = dpi(40),
            widget = wibox.container.margin
        },
        bg = beautiful.layoutlist_bg_normal,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 5)
        end,
        widget = wibox.container.background,
        screen = s
    }

    layout:buttons(
        awful.util.table.join(
            awful.button({}, 1, function() awful.layout.inc(1, s) end),
            awful.button({}, 3, function() awful.layout.inc(-1, s) end),
            awful.button({}, 4, function() awful.layout.inc(1, s) end),
            awful.button({}, 5, function() awful.layout.inc(-1, s) end) 
        )
    )

    return layout
end

return layoutlist_widget
