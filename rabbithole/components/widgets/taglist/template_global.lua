local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
return function (controller)
    return
    {
        id     = 'background_role',
        widget = wibox.container.background,
        {
            left  = dpi(3),
            right = dpi(3),
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    left = dpi(2),
                },
                {
                    widget = wibox.container.margin,
                    top = dpi(4),
                    bottom = dpi(4),
                    {
                        widget = wibox.container.background,
                        shape = function(cr, width, height)
                            gears.shape.rounded_rect(cr, width, height, 8)
                        end,
                        bg = beautiful.bg_normal,
                        {
                            widget = wibox.container.margin,
                            left = dpi(2),
                            right = dpi(2),
                            {
                                id     = 'text_role',
                                widget = wibox.widget.textbox,
                            },
                        },
                    },
                },
            },
        },

        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end
