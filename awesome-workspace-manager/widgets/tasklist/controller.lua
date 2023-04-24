local awful = require("awful")
local gears = require("gears")

local _M = {}

function _M.create_buttons()
    return gears.table.join(
        awful.button({}, 1, function(c)
            c:activate { context = "tasklist", action = "mouse_click" }
        end),
        awful.button({}, 3, function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),
        awful.button({}, 4, function()
            awful.client.focus.byidx(1)
        end),
        awful.button({}, 5, function()
            awful.client.focus.byidx(-1)
        end)
    )
end

return _M
