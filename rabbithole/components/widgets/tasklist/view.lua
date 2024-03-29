local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local generate_filter = function(t)
    return function(c, scr)
        local ctags = c:tags()
        for _, v in ipairs(ctags) do
            if v == t then
                return true
            end
        end
        return false
    end
end

return function (controller)
    return wibox.widget {
        {
            widget = wibox.container.margin,
            left = dpi( 5 ),
        },
        {
            awful.widget.tasklist({
                screen = controller.screen,
                filter  = generate_filter(controller.tag),
                buttons = controller.tasklist_buttons,
                widget_template = {
                    {
                        {
                            {
                                id = "icon_role",
                                widget = wibox.widget.imagebox,
                                forced_height = dpi( 24 ),
                            },
                            --id = "icon_margin_role",
                            widget = wibox.container.margin,
                            margins = dpi( 4 ),
                        },
                        id = 'background_role',
                        widget = wibox.container.background,
                    },
                    layout = wibox.layout.stack,
                    create_callback = function(tasklist, c, _, _)
                        controller:create_callback(tasklist, c, _, _)
                    end,
                },
            }),
            widget = wibox.container.background,
            bg = beautiful.tasklist_bg_normal,
            shape = gears.shape.rounded_rect,
            shape_border_width = dpi( 1 ),
            shape_border_color = beautiful.tasklist_bg_normal,
        },
        layout = wibox.layout.fixed.horizontal,
    }
end
