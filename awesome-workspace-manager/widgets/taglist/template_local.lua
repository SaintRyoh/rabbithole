local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local gradient_bg = beautiful.taglist_bg_focus

return function (controller)
    return {
        widget = wibox.container.background,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        bg = beautiful.bg_normal,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                id     = 'index_role',
                widget = wibox.widget.textbox,
            },
            {
                widget = wibox.container.margin,
                top = 10, -- Increase top margin here
                bottom = 10, -- Increase bottom margin here
                {
                    widget = wibox.container.background,
                    shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, 10)
                    end,
                    bg = gradient_bg,
                    {
                        layout = wibox.layout.fixed.horizontal,
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
