local wibox = require("wibox")

local _M = {}

function _M.create(tasklist_buttons)
    return wibox.widget {
        layout = wibox.layout.flex.horizontal,
        spacing = 5,
        spacing_widget = {
            valign = 'center',
            halign = 'center',
            widget = wibox.container.place,
        },
        widget_template = {
            {
                {
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget  = wibox.container.margin,
                },
                id     = 'background_role',
                widget = wibox.container.background,
            },
            forced_width     = 24,
            forced_height    = 24,
            id               = 'icon_role',
            widget           = wibox.container.constraint,
        },
        buttons = tasklist_buttons,
    }
end

return _M
