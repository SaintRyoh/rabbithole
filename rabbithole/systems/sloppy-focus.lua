
local beautiful = require("beautiful")

capi = {
    client = client,
    awesome = awesome
}

return setmetatable({}, {
    __constructor = function()
        -- Enable sloppy focus, so that focus follows mouse.
        capi.client.connect_signal("mouse::enter", function(c)
            c:emit_signal("request::activate", "mouse_enter", {raise = true})
        end)

        capi.client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)

        capi.client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
    end,
})

-- }}}