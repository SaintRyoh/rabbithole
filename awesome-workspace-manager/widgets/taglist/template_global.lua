local wibox = require("wibox")


return function (controller)
    return 
    {
        id     = 'background_role',
        widget = wibox.container.background,
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

        -- Add support for hover colors and an index label
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end