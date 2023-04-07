local wibox = require("wibox")


return function (controller)
    -- RC.debugger.dbg()
    return {
        id     = 'background_role',
        widget = wibox.container.background,
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
            },
        },

        -- Add support for hover colors and an index label
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end