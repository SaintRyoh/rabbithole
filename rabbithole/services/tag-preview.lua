local gears = require("gears")
local Module = {}
Module.__index = Module

local visible = false

function Module.new()
    local self = {}
    setmetatable(self, Module)

    return self
end

function Module.show(tag, screen)
    -- BLING: Only show widget when there are clients in the tag
    if #tag:clients() > 0 and not visible then
        -- BLING: Update the widget with the new tag
        awesome.emit_signal("bling::tag_preview::update", tag)
        -- BLING: Show the widget
        awesome.emit_signal("bling::tag_preview::visibility", screen, true)
        visible = true
    end
end

function Module.hide(screen)
    -- BLING: Turn the widget off
    if visible then
        awesome.emit_signal("bling::tag_preview::visibility", screen, false)
        visible = false
    end
end

return Module