-- Left floating container wibox for rabid
-- Awesome Libs
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")


return function(s, widgets)

    local top_left = awful.popup {
        screen = s,
        widget = wibox.container.background,
        ontop = false,
        bg = beautiful.left_bar_color,
        visible = true,
        maximum_width = dpi(700),
        placement = function(c)
            awful.placement.top(c, { margins = dpi(10) })
        end,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        shape_clip = true,
        shape_border_width = dpi(3),
        shape_outline_width = dpi(1)
    }

    -- This is how close clients will get to the wibar
    top_left:struts{top = 55}

    local function prepare_widgets(widgets)
        local layout = {
            forced_height = 40,
            layout = wibox.layout.fixed.horizontal
        }
        for i, widget in pairs(widgets) do
            if i == 1 then
                table.insert(layout, {
                    widget,
                    left = dpi(6),
                    right = dpi(3),
                    top = dpi(6),
                    bottom = dpi(6),
                    widget = wibox.container.margin
                })
            elseif i == #widgets then
                table.insert(layout, {
                    widget,
                    left = dpi(3),
                    right = dpi(6),
                    top = dpi(6),
                    bottom = dpi(6),
                    widget = wibox.container.margin
                })
            else
                table.insert(layout, {
                    widget,
                    left = dpi(3),
                    right = dpi(3),
                    top = dpi(6),
                    bottom = dpi(6),
                    widget = wibox.container.margin
                })
            end
        end
        return layout
    end

    top_left:setup{
        prepare_widgets(widgets),
        nil,
        nil,
        layout = wibox.layout.fixed.horizontal
    }
end
