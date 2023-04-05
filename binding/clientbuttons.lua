-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __constructor = function (settings)
        
    local modkey = settings.modkey
    local clientbuttons = gears.table.join(
            awful.button({ }, 1, function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
            end),
            awful.button({ modkey }, 1, function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.move(c)
            end),
            awful.button({ modkey }, 3, function (c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.resize(c)
            end)
    )

    return clientbuttons
    end
})