-- Awesome Libs
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")


-- Returns a widget for wonderland_ctlbar
return function(s, widgets)
    -- create right wibar as a floating popup widget
    local wonderland_ctlbar = awful.popup {
        widget = wibox.container.background,
        ontop = false,
        bg = beautiful.bg_normal,
        visible = true,
        screen = s,
        maximum_width = dpi(200),
        placement = function(c)
            awful.placement.top_right(c, { margins = dpi(3) })
        end,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end
    }
    -- this sets the distance between the top of the screen and the clients
    wonderland_ctlbar:struts {
        top = dpi(34)
    }

    local function prepare_widgets(widgets)
        local layout = {
            forced_height = dpi(28),
            layout = wibox.layout.fixed.horizontal
        }
        for i, widget in pairs(widgets) do
            if i == 1 then
                table.insert(layout,
                    {
                        widget,
                        left = dpi(6),
                        right = dpi(3),
                        top = dpi(4),
                        bottom = dpi(4),
                        widget = wibox.container.margin
                    })
            elseif i == #widgets then
                table.insert(layout,
                    {
                        widget,
                        left = dpi(3),
                        right = dpi(6),
                        top = dpi(4),
                        bottom = dpi(4),
                        widget = wibox.container.margin
                    })
            else
                table.insert(layout,
                    {
                        widget,
                        left = dpi(3),
                        right = dpi(3),
                        top = dpi(4),
                        bottom = dpi(4),
                        widget = wibox.container.margin
                    })
            end
        end
        return layout
    end

    wonderland_ctlbar:setup {
        nil,
        nil,
        prepare_widgets(widgets),
        layout = wibox.layout.align.horizontal
    }
end
