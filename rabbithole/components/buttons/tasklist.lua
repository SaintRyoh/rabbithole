local awful = require("awful")
local gears = require("gears")
local dragndrop = require("rabbithole.components.buttons.dragndrop")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__menus__tasklist
    )
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
                -- middle click to kill client
                awful.button({ }, 2, function(c)
                    c:kill()
                end),
                awful.button({ }, 3, function(c)
                    rabbithole__components__menus__tasklist(c):toggle()
                end)
        )

        -- Enable drag and drop for each client
        --for _, c in ipairs(client.get()) do
        --    dragndrop.enableDrag(c)
        --end
--
        ---- Enable drag and drop for new clients
        --client.connect_signal("manage", function(c)
        --    dragndrop.enableDrag(c)
        --end)

        return tasklist_buttons
    end
})
