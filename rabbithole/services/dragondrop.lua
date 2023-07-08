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

function DragonDrop:drag(c, hovered_tag)
    self.client = c
    print(hovered_tag)
    print(self.client)
    self.og_tag = c.first_tag

    -- Connect to the "button::release" 
    self.wibox = mouse.current_widgets[1]
    self.wibox:connect_signal("button::release", function()
        self:drop()
    end)
end

function DragonDrop:drop()
    print("The mouse button has been released.\n\n Tag under pointer below")
    local tag_under_pointer = awful.screen.focused().selected_tag
    print(tag_under_pointer)
    if tag_under_pointer ~= self.og_tag then
        print("making sure the client matches above")
        print(self.client)
        self.client:move_to_tag(tag_under_pointer)
    end

    -- Disconnect from the "button::release" signal
    self.wibox:disconnect_signal("mouse::release", function() self:drop() end)
end

return DragonDrop
