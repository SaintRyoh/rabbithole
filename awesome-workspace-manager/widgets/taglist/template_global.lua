local wibox = require("wibox")
local awful = require("awful")

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
                    widget = wibox.container.background,
                    fg = "#FFFFFF",
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 5,
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
                            id     = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                    },
                },
            },
        },

        -- Add support for hover colors and an index label
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end
