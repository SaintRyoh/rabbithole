local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local _M = {}

function _M.get(controller)
    local Template = {}
    local animation = nil

    Template.root = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        bind = "root",
        signals = {
            ["mouse::enter"] = function(widget, bindings)
                -- widget.bg = beautiful.bg_focus
                animation.target = 1
            end,
            ["mouse::leave"] = function(widget, bindings)
                -- widget.bg = beautiful.bg_normal
                animation.target = 0
            end
        },
        t_buttons = {
            function(widget, bindings)
                return awful.button({}, 1, function(event)
                    if bindings.menu.wibox.visible == true then
                        bindings.menu:hide()
                        bindings.root.bg = beautiful.bg_normal
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
                widget = wibox.widget.imagebox,
                bind = "workspace_icon",
                resize = true,
                forced_height = 30,
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

    animation = controller.animation({
        duration = 0.4,
        rapid_set = true,
        pos = 0,
        subscribed = function(pos)
            if type(Template.root.bg) == "string" then
                Template.root.bg = controller.colors.blend_colors(beautiful.bg_normal, beautiful.bg_focus, pos)
            else
                Template.root.bg = controller.color.twoColorTrue3d(
                    controller.color.blend_colors(beautiful.base_color, beautiful.tertiary_1, pos), 
                    controller.color.blend_colors(beautiful.secondary_color, beautiful.tertiary_2, pos)
                )
            end
        end
    })

    return Template
end

return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })
