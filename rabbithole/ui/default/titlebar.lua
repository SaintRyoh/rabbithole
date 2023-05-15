local awful = require("awful")
local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__buttons__titlebar,
        rabbithole__services__icon___handler
    )
        return function (c)
            local client_icon = rabbithole__services__icon___handler:get_icon_by_client(c)
            awful.titlebar(c) : setup {
                { -- Left
                    {
                        image = client_icon,
                        widget = wibox.widget.imagebox,
                        resize = true
                    },
                    buttons = rabbithole__components__buttons__titlebar(c),
                    layout  = wibox.layout.fixed.horizontal
                },
                { -- Middle
                    { -- Title
                        align  = "center",
                        widget = awful.titlebar.widget.titlewidget(c)
                    },
                    buttons = rabbithole__components__buttons__titlebar(c),
                    layout  = wibox.layout.flex.horizontal
                },
                { -- Right
                    --awful.titlebar.widget.floatingbutton (c),
                    awful.titlebar.widget.maximizedbutton(c),
                    --awful.titlebar.widget.stickybutton   (c),
                    --awful.titlebar.widget.ontopbutton    (c),
                    awful.titlebar.widget.closebutton    (c),
                    layout = wibox.layout.fixed.horizontal()
                },
                layout = wibox.layout.align.horizontal
            }
        end
    end,
})