-- module("anybox.titlebar", package.seeall)

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


return setmetatable({}, {
    __constructor = function(awesome___workspace___manager__menus__tasklistmenu)
        -- Add a titlebar if titlebars_enabled is set to true in the rules.
        client.connect_signal("request::titlebars", function(c)
            local tasklistmenu = awesome___workspace___manager__menus__tasklistmenu
            -- buttons for the titlebar
            local buttons = gears.table.join(
                    awful.button({ }, 1, function()
                        c:emit_signal("request::activate", "titlebar", {raise = true})
                        awful.mouse.client.move(c)
                    end),
                    awful.button({ "Shift" }, 3, function()
                        c:emit_signal("request::activate", "titlebar", {raise = true})
                        awful.mouse.client.resize(c)
                    end),
                    awful.button({ }, 3, function()
                        tasklistmenu:updateMenu(c)
                        tasklistmenu.tasklist_menu:toggle()
                    end)
            )

            awful.titlebar(c) : setup {
                { -- Left
                    awful.titlebar.widget.iconwidget(c),
                    buttons = buttons,
                    layout  = wibox.layout.fixed.horizontal
                },
                { -- Middle
                    { -- Title
                        align  = "center",
                        widget = awful.titlebar.widget.titlewidget(c)
                    },
                    buttons = buttons,
                    layout  = wibox.layout.flex.horizontal
                },
                { -- Right
                    awful.titlebar.widget.floatingbutton (c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.stickybutton   (c),
                    awful.titlebar.widget.ontopbutton    (c),
                    awful.titlebar.widget.closebutton    (c),
                    layout = wibox.layout.fixed.horizontal()
                },
                layout = wibox.layout.align.horizontal
            }
        end)
    end,
})