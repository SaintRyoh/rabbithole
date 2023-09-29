local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

return function (controller)
    local true3d = controller.color.twoColorTrue3d(beautiful.base_color, beautiful.secondary_color)
    return {
        --id = "background_role",
        widget = wibox.container.background,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        bg = true3d,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                top = dpi(4),
                bottom = dpi(4),
                left = dpi(2),
                right = dpi(2),
                {
                    --id = "background_role",
                    widget = wibox.container.background,
                    shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, 8)
                    end,
                    bg = true3d,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id     = 'index_role',
                            widget = wibox.widget.textbox,
                        },
                        {
                            id     = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                        {
                            id = "icon_container",
                            widget = wibox.container.place,
                            {
                                widget = wibox.layout.fixed.horizontal,
                            }
                        },
                    },
                },
            },
        },
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,
        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end
