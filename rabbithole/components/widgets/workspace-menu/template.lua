local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local WorkspaceMenuTemplate = {}

local function handleMouseAction(debounce_timer, animation, pending_action)
    if not debounce_timer.started then
        debounce_timer:start()
    elseif pending_action then
        debounce_timer:stop()
        debounce_timer:start()
    end
end

function WorkspaceMenuTemplate.get(controller)
    local Template = {}
    local animation

    local debounce_timer = gears.timer({ timeout = 0.1 })
    local pending_action

    debounce_timer:connect_signal("timeout", function()
        animation.target = (pending_action == "enter") and 1 or 0
        debounce_timer:stop()
        pending_action = nil
    end)

    Template.root = wibox.widget {
        widget = wibox.container.background,
        bind = "root",
        signals = {
            ["mouse::enter"] = function()
                pending_action = "enter"
                handleMouseAction(debounce_timer, animation, pending_action)
            end,
            ["mouse::leave"] = function()
                pending_action = "leave"
                handleMouseAction(debounce_timer, animation, pending_action)
            end
        },
        t_buttons = {
            function(widget, bindings)
                return awful.button({}, 1, function(event)
                    local isVisible = bindings.menu.wibox.visible
                    if isVisible then
                        bindings.menu:hide()
                        bindings.root.bg = beautiful.bg_normal
                        bindings.rotator.direction = "north"
                    else
                        bindings.menu:show({
                            coords = {
                                x = event.x,
                                y = event.y
                            }
                        })
                        bindings.root.bg = beautiful.bg_focus
                        bindings.rotator.direction = "west"
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
            Template.root.bg = (type(Template.root.bg) == "string") 
            and controller.color.twoColorTrue3d(beautiful.base_color, beautiful.secondary_color) 
            or controller.color.twoColorTrue3d(
                controller.color.blend_colors(beautiful.base_color, beautiful.tertiary_1, pos), 
                controller.color.blend_colors(beautiful.secondary_color, beautiful.tertiary_2, pos)
            )
        end
    })

    return Template
end

return setmetatable({}, { __call = function(_, controller) return WorkspaceMenuTemplate.get(controller) end })
