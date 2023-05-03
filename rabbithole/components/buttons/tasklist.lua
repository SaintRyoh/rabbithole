local awful = require("awful")
local gears = require("gears")

return setmetatable({}, {
    __constructor = function ()
        local tasklist_buttons = gears.table.join(
                awful.button({ }, 1, function (c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c:emit_signal(
                                "request::activate",
                                "tasklist",
                                {raise = true}
                        )
                    end
                end),
                awful.button({ }, 3, function(c)
                    -- tasklistmenu:updateMenu(c)
                    -- tasklistmenu.tasklist_menu:toggle()
                end),
                awful.button({ }, 4, function ()
                    awful.client.focus.byidx(1)
                end),
                awful.button({ }, 5, function ()
                    awful.client.focus.byidx(-1)
                end)
        )

        return tasklist_buttons
    end
})