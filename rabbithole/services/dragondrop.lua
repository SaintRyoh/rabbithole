-- DragonDrop is a service that allows you to drag clients between tags.
-- It is used in rabbithole/components/buttons/tasklist.lua to allow you to
-- drag clients between tags from the tasklist widget.

local awful = require("awful")
local DragonDrop = {}
DragonDrop.__index = DragonDrop

function DragonDrop.new()
    local self = setmetatable({ }, DragonDrop)

    self.og_tag = nil
    self.client = nil
    self.wibox = nil

    return self
end

function DragonDrop:drag(c)
    self.client = c
    self.og_tag = c.first_tag

    print("The mouse button is being held.")

    -- Connect to the "button::release" signal on the root widget
    self.wibox = mouse.current_widgets[1]
    self.wibox:connect_signal("mouse::release", function() self:drop() end)
end

function DragonDrop:drop()
    print("The mouse button has been released.\n\n The tag ID is below")
    local tag_under_pointer = awful.screen.focused().selected_tag
    print(tag_under_pointer)
    if tag_under_pointer ~= self.og_tag then
        self.client:move_to_tag(tag_under_pointer)
    end

    -- Disconnect from the "button::release" signal
    self.wibox:disconnect_signal("mouse::release", function() self:drop() end)
end

return DragonDrop
