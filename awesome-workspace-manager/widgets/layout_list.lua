-- layoutlist_widget.lua

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
            forced_width = dpi(40),
            widget = wibox.container.margin
        },
        bg = beautiful.layoutlist_bg_normal, -- Use beautiful.layoutlist_bg_normal as the background color
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 5)
        end,
        widget = wibox.container.background,
        screen = s
    }

    return layout
end

return layoutlist_widget
