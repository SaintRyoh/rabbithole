local awful = require("awful")
local gears = require("gears")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__menus__tasklist
    )
        local tasklist_buttons = gears.table.join(
                -- NOTE: i DONT THINK WE NEED THIS LOGIC ANYMORE BECAUSE OF THE DRAGONDROP MODULE LOGIC
                --awful.button({ }, 1, function (c)
                --    if c == client.focus then
                --        c.minimized = true
                --    else
                --        c:emit_signal(
                --                "request::activate",
                --                "tasklist",
                --                {raise = true}
                --        )
                --    end
                --end),
                -- middle click to kill client
                awful.button({ }, 2, function(c)
                    c:kill()
                end),
                awful.button({ }, 3, function(c)
                    rabbithole__components__menus__tasklist(c):toggle()
                end)
        )

        return tasklist_buttons
    end
})