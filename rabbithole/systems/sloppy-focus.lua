
local beautiful = require("beautiful")


return setmetatable({}, {
    __constructor = function()
        -- Enable sloppy focus, so that focus follows mouse.
        client.connect_signal("mouse::enter", function(c)
            c:emit_signal("request::activate", "mouse_enter", {raise = false})
        end)

        client.connect_signal("mouse::leave", function(c)
            c:emit_signal("request::activate", "mouse_leave", {raise = false})
        end)

        client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)

        client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
    end,
})

-- }}}