local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local icon_path = awful.util.getdir("config") .. "/src/assets/icons/rabbithole/global.svg"

return function (controller)
    return
    {
        id     = 'background_role',
        widget = wibox.container.background,
        {
            left  = 3,
            right = 18,
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    left = 5,
                },
                {
                    widget = wibox.container.margin,
                    left = 5,
                    right = 5,
                    {
                        widget = wibox.widget.imagebox,
                        image = icon_path,
                    },
                },
                {
                    widget = wibox.container.margin,
                    top = 8,
                    bottom = 8,
                    {
                        widget = wibox.container.background,
                        shape = function(cr, width, height)
                            gears.shape.rounded_rect(cr, width, height, 8)
                        end,
                        bg = beautiful.bg_normal,
                        border_color = "#FFFFFF",
                        border_width = 2,
                        {
                            widget = wibox.container.margin,
                            left = 4,
                            right = 4,
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
