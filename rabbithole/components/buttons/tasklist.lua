local awful = require("awful")
local gears = require("gears")
local dragndrop = require("rabbithole.services.dragondrop")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__menus__tasklist
    )
        local dragndrop = dragndrop.new()
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
                    dragndrop:drag(c)
                end),
                -- middle click to kill client
                awful.button({ }, 2, function(c)
                    c:kill()
                end),
                awful.button({ }, 3, function(c)
                    rabbithole__components__menus__tasklist(c):toggle()
                end),
                awful.button({ }, 1, function (c)
                    dragndrop:drop(c)
                end)
        )

        return tasklist_buttons
    end
})