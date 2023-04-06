local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local __ = require("lodash")
local color = require("src.themes.rabbithole.colors")


local _M = {}

function _M.get(controller)
    return {
        layout = wibox.layout.fixed.horizontal,
        create_callback = function(self, object, index, objects)
            local tag_widget = wibox.widget {
                {
                    {
                        {
                            {
                                text = "",
                                align = "center",
                                valign = "center",
                                visible = true,
                                font = "#000000", -- TODO: Replace with  colors.lua when recreated
                                forced_width = dpi(25),
                                id = "label",
                                widget = wibox.widget.textbox
                            },
                            id = "margin",
                            left = dpi(5),
                            right = dpi(5),
                            widget = wibox.container.margin
                        },
                        id = "container",
                        layout = wibox.layout.fixed.horizontal
                    },
                    fg = "#000000", -- Replace with the appropriate color value
                    shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, 8)
                    end,
                    widget = wibox.container.background
                }
            }

            tag_widget.container.margin.label:set_text(object.index)
            if object.urgent == true then
              tag_widget:set_bg(color["RedA200"])
              tag_widget:set_fg(color["Grey900"])
            elseif object == awful.screen.focused().selected_tag then
              tag_widget:set_bg(color["LightBlue50"])
              tag_widget:set_fg(color["Grey900"])
            else
              tag_widget:set_bg(beautiful.widget_bg_gradient)
            end

            -- Set the icon for each client
            for _, client in ipairs(object:clients()) do
              tag_widget.container.margin:set_right(0)
              local icon = wibox.widget {
                {
                  id = "icon_container",
                  {
                    id = "icon",
                    resize = true,
                    widget = wibox.widget.imagebox
                  },
                  widget = wibox.container.place
                },
                forced_width = dpi(25),
                margins = dpi(3),
                widget = wibox.container.margin
              }
              --icon.icon_container.icon:set_image(Get_icon(user_vars.icon_theme, client))
              tag_widget.container:setup({
                icon,
                strategy = "exact",
                layout = wibox.container.constraint,
              })
            end
            -- mouse signals for each tag button
            local old_wibox, old_cursor, old_bg
            tag_widget:connect_signal(
                "mouse::enter",
                function()
                    old_bg = tag_widget.bg
                    if object == awful.screen.focused().selected_tag then
                        tag_widget.bg = '#dddddd' .. 'dd'
                    else
                        tag_widget.bg = '#3A475C' .. 'dd'
                    end
                    local w = mouse.current_wibox
                    if w then
                        old_cursor, old_wibox = w.cursor, w
                        w.cursor = "hand1"
                    end
                end
            )

            tag_widget:connect_signal(
                "button::press",
                function()
                    if object == awful.screen.focused().selected_tag then
                        tag_widget.bg = '#bbbbbb' .. 'dd'
                    else
                        tag_widget.bg = '#3A475C' .. 'dd'
                    end
                end
            )

            tag_widget:connect_signal(
                "button::release",
                function()
                    if object == awful.screen.focused().selected_tag then
                        tag_widget.bg = '#dddddd' .. 'dd'
                    else
                        tag_widget.bg = '#3A475C' .. 'dd'
                    end
                end
            )

            tag_widget:connect_signal(
                "mouse::leave",
                function()
                    tag_widget.bg = old_bg
                    if old_wibox then
                        old_wibox.cursor = old_cursor
                        old_wibox = nil
                    end
                end
            )

            self:get_children_by_id("label")[1]:set_text(index)
            self:get_children_by_id("container")[1]:add(tag_widget)

            -- Update the background color based on the state
            object:connect_signal("property::selected", function()
                if object.selected then
                    tag_widget.bg = '#dddddd' .. 'dd'
                else
                    tag_widget.bg = '#3A475C' .. 'dd'
                end
            end)

            object:connect_signal("property::urgent", function()
                if object.urgent then
                    tag_widget.bg = '#ff0000' .. 'dd'
                else
                    tag_widget.bg = '#3A475C' .. 'dd'
                end
            end)
        end,
        update_callback = function(self, object, index, objects)
            self:get_children_by_id("label")[1]:set_text(index)
        end,
    }
end

return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })
