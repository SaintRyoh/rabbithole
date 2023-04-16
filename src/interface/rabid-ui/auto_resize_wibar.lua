local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local function create_autoresize_wibox(args)
    local args = args or {}
    local w = wibox(args)
    
    -- Wrap the widget in a wibox layout to handle size changes
    local layout = wibox.layout.fixed.horizontal()
    layout:add(w)
    w:set_widget(layout)

    -- Function to update the wibox size
    local function update_size()
        local content_size = w.widget:fit({dpi=96}, math.huge, math.huge)
        w.width = content_size
    end

    -- Connect to the relevant signals
    w.widget:connect_signal("widget::layout_changed", update_size)
    w.widget:connect_signal("widget::redraw_needed", update_size)

    return w
end

return setmetatable({}, { __call = function(_, ...) return create_autoresize_wibox(...) end })
