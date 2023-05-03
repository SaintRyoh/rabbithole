local gears = require("gears")
local awful = require("awful")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__menus__tasklist___menu
    )
        return function (client)
            return gears.table.join(
                    awful.button({ }, 1, function()
                        client:emit_signal("request::activate", "titlebar", {raise = true})
                        awful.mouse.client.move(client)
                    end),
                    awful.button({ "Shift" }, 3, function()
                        client:emit_signal("request::activate", "titlebar", {raise = true})
                        awful.mouse.client.resize(client)
                    end),
                    awful.button({ }, 3, function()
                        rabbithole__components__menus__tasklist___menu(client):toggle()
                    end)
            )
        end
    end
})