local wibox = require("wibox")
local gears = require("gears")

return function (controller)
    return {
        -- for some reason, having the container with the id=background role makes it not take a shape
        id     = 'background_role',
        widget = wibox.container.background,
        {
            widget = wibox.container.margin,
            {
                left  = 5,
                right = 5,
                widget = wibox.container.margin,
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        id     = 'index_role',
                        widget = wibox.widget.textbox,
                    },
                    {
                        widget = wibox.container.margin,
                        left = 5,
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

        -- Add support for hover colors and an index label
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end
