local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local __ = require("lodash")

local _M = {}

function _M.get(controller)
    local Template = {}

    Template.root = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        bind = "root",
        signals = {
            ["mouse::enter"] = function(widget, bindings)
                widget.bg = beautiful.bg_focus
            end,
            ["mouse::leave"] = function(widget, bindings)
                widget.bg = beautiful.bg_normal
            end
        },
        t_buttons = {
            function(widget, bindings)
                return awful.button({}, 1, function(event)
                    if bindings.menu.wibox.visible == true then
                        bindings.menu:hide()
                    else
                        bindings.rotator.direction = "west"
                        bindings.root.bg = beautiful.bg_focus
                        bindings.menu:show({
                            coords = {
                                x = event.x,
                                y = event.y
                            }
                        })
                    end
                end)
            end
        },
        {
            widget = wibox.container.margin,
            margins = 3,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.widget.imagebox,
                    bind = "workspace_icon",
                    resize = true,
                    forced_height = 30,
                },
                {
                    -- padding between icon and workspace name
                    widget = wibox.container.margin,
                    left = 5, -- Adjust this value for desired padding
                },
                -- Workspace name container
                {
                    widget = wibox.container.background,
                    bg = beautiful.bg_normal,
                    {
                        widget = wibox.widget.textbox,
                        bind = "workspace_name",
                    },
                    bind = "workspace_name_container"
                },

                {
                    widget = wibox.container.rotate,
                    direction = "north",
                    {
                        widget = wibox.container.margin,
                        margins = 3,
                        {
                            image = beautiful.menu_submenu_icon,
                            resize = true,
                            widget = wibox.widget.imagebox,
                            bind = "open_close_indicator"
                        }
                    },
                    bind = "rotator"
                }
            }
        },
    }

    return Template
end

return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })
