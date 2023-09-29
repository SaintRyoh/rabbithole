local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local WorkspaceMenuTemplate = {}

function WorkspaceMenuTemplate.get(controller)
    local beautiful = require("beautiful")
    local Template = {}
    local animation = nil
    local debounce_timer = gears.timer({ timeout = 0.1 })
    local pending_action = nil

    Template.root = wibox.widget {
        widget = wibox.container.background,
        --bg = beautiful.secondary_color,
        bind = "root",
        signals = {
            ["mouse::enter"] = function(widget)
                if not debounce_timer.started then
                    pending_action = "enter"
                    debounce_timer:start()
                else
                    if pending_action == "leave" then
                        debounce_timer:stop()
                        pending_action = "enter"
                        debounce_timer:start()
                    end
                end
            end,
            ["mouse::leave"] = function(widget)
                if not debounce_timer.started then
                    pending_action = "leave"
                    debounce_timer:start()
                else
                    if pending_action == "enter" then
                        debounce_timer:stop()
                        pending_action = "leave"
                        debounce_timer:start()
                    end
                end
            end
        },
        debounce_timer:connect_signal("timeout", function()
            if pending_action == "enter" then
                animation.target = 1
            elseif pending_action == "leave" then
                animation.target = 0
            end
            debounce_timer:stop()
            pending_action = nil
        end),
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
                    margins = 0,
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
        duration = 0.2,
        rapid_set = true,
        pos = 0,
        subscribed = function(pos)
            if type(Template.root.bg) == "string" then
                Template.root.bg = controller.color.twoColorTrue3d(beautiful.base_color, beautiful.secondary_color)
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

return setmetatable({}, { __call = function(_, controller) return WorkspaceMenuTemplate.get(controller) end })
