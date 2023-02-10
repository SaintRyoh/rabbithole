local wibox = require("wibox")
local beautiful = require("beautiful")

local Template = { }

Template.root = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.bg_normal,
    bind = "root",
    {
        widget = wibox.container.margin,
        margins = 3,
        {
            layout = wibox.layout.fixed.horizontal,
            {
                text = "initial text",
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox,
                bind = "textbox"
            },
            {
                widget = wibox.container.rotate,
                direction = "north",
                {
                    widget = wibox.container.margin,
                    margins = 3,
                    {
                        image = beautiful.menu_submenu_icon,
                        resize = true,
                        widget = wibox.widget.imagebox,
                        bind = "open_close_indicator"
                    }
                },
                bind = "rotator"
            }
        }
    },
}

return Template