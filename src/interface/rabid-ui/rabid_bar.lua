-- Left floating container wibox for rabid
-- Awesome Libs
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")


return function(s, widgets)

    local rabid_bar = awful.popup {
        screen = s,
        widget = wibox.container.background,
        ontop = false,
        bg = beautiful.bg_normal, -- requires picom to be turned on
        visible = true,
        maximum_width = dpi(500),
        placement = function(c)
            awful.placement.top(c, {
                -- margine below top and botton of rabid_bar
                margins = dpi(3)
            })
        end,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 5)
        end
    }

    rabid_bar:struts{top = dpi(35)}

    local function prepare_widgets(widgets)
        local layout = {
            forced_height = dpi(28),
            layout = wibox.layout.fixed.horizontal
        }
        for i, widget in pairs(widgets) do
            -- first widges gaps
            if i == 1 then
                table.insert(layout, {
                    widget,
                    left = dpi(6),
                    right = dpi(3),
                    top = dpi(4),
                    bottom = dpi(4),
                    widget = wibox.container.margin
                })
            -- last widgets gaps
            elseif i == #widgets then
                table.insert(layout, {
                    widget,
                    left = dpi(3),
                    right = dpi(6),
                    top = dpi(4),
                    bottom = dpi(4),
                    widget = wibox.container.margin
                })
            -- middle widgets gaps
            else
                table.insert(layout, {
                    widget,
                    left = dpi(3),
                    right = dpi(3),
                    top = dpi(4),
                    bottom = dpi(4),
                    widget = wibox.container.margin
                })
            end

            -- Connect signal to refresh the wibox size when child widget changes size
            widget:connect_signal("widget::layout_changed", function()
                rabid_bar.width = rabid_bar.widget:fit(
                    rabid_bar.screen.dpi,
                    rabid_bar.widget:layout().forced_width,
                    rabid_bar.widget:layout().forced_height
                )
            end)
            widget:connect_signal("widget::updated", function()
                local new_width = widget:get_preferred_size()
                self.popup_widget.width = new_width.width
                self.popup_widget.height = new_width.height
            end)

        end
        return layout
    end

    rabid_bar:setup{
        prepare_widgets(widgets),
        nil,
        nil,
        layout = wibox.layout.fixed.horizontal
    }
end
