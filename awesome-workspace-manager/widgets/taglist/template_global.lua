local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local config_dir = awful.util.getdir("config")
local glass_texture_path = config_dir .. "/src/assets/textures/glass_texture.svg"

return function (controller)
    return
    {
        id     = 'background_role',
        widget = wibox.container.background,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,

        {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.place,
                {
                    id = 'bg_image',
                    widget = wibox.widget.imagebox,
                    image = glass_texture_path,
                    resize = true,
                },
            },
            {
                left  = 18,
                right = 18,
                widget = wibox.container.margin,
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.container.margin,
                        left = 5,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                },
            },
        },

        -- Add support for hover colors and an index label
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects)
            local bg_image = objects.bg_image
            local widget_width = tag_template:get_width()
            local widget_height = tag_template:get_height()

            bg_image.forced_width = widget_width
            bg_image.forced_height = widget_height

            controller:update_tag_callback(tag_template, tag, index, objects)
        end,
    }
end
