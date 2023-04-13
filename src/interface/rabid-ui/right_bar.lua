-- Awesome Libs
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
-- Custom local libraries
local color = RC.colors

-- This returns a widget for the right bar
return function(s, widgets)
    -- create right wibar as a floating popup widget
    local top_right = awful.popup {
        widget = wibox.container.background,
        ontop = false,
        bg = beautiful.right_bar_color,
        visible = true,
        screen = s,
        placement = function(c) awful.placement.top_right(c, { margins = dpi(10) }) end,
        -- rounded edges
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end
    }
    -- this sets the distance between the top of the screen and the clients
    top_right:struts {
        top = 55
    }

    local function prepare_widgets(widgets)
        local layout = {
            forced_height = 40,
            layout = wibox.layout.fixed.horizontal
        }
        for i, widget in pairs(widgets) do
            if i == 1 then
                table.insert(layout,
                    {
                        widget,
                        left = dpi(6),
                        right = dpi(3),
                        top = dpi(6),
                        bottom = dpi(6),
                        widget = wibox.container.margin
                    })
            elseif i == #widgets then
                table.insert(layout,
                    { 
                        widget,
                        left = dpi(3),
                        right = dpi(6),
                        top = dpi(6),
                        bottom = dpi(6),
                        widget = wibox.container.margin
                    })
            else
                table.insert(layout,
                    {
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

    top_right:setup {
        nil,
        nil,
        prepare_widgets(widgets),
        layout = wibox.layout.align.horizontal
    }
end
