local awful = require("awful")
local wibox = require("wibox")

local _M = {}

function _M.get(controller)
    local beautiful = require("beautiful")
    local Template = {}
    local animation = nil

    Template.root = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.secondary_color,
        bind = "root",
        signals = {
            ["mouse::enter"] = function(widget)
                animation.target = 1
            end,
            ["mouse::leave"] = function(widget)
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
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.widget.imagebox,
                bind = "workspace_icon",
                resize = true,
                forced_height = 30,
            },
            {
                widget = wibox.container.rotate,
                direction = "north",
                bind = "rotator",
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
            }
        },
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
