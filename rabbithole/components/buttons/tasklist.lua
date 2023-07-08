local awful = require("awful")
local gears = require("gears")
local dragndrop = require("rabbithole.services.dragondrop")

return setmetatable({ }, {
    __constructor = function (
        rabbithole__components__menus__tasklist
    )
        local tasklist_buttons = gears.table.join(
                awful.button({ }, 1, function (c)
                    dragndrop:drag(c)
                    --c:connect_signal("mouse::pressed", function() dragndrop:drag(c) end)
                    --c:connect_signal("mouse::released", function() dragndrop:drop() end)
                end),
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
