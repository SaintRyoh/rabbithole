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
    self.hovered_tag = nil

    return self
end

function DragonDrop:drag(client, origin_tag)
    self.client = client
    self.origin_tag = origin_tag

    -- Connect to the "button::release" 
    --self.wibox = mouse.current_widgets[1]
    --print(self.wibox)
    --self.wibox:connect_signal("button::release", function()
    --    self:drop()
    --end)
end

function DragonDrop:drop(hovered_tag)
    self.hovered_tag = hovered_tag
    print("Tag under pointer below (screen.focused().selected_tag")
    --local tag_under_pointer = awful.screen.focused().selected_tag
    print(tag_under_pointer)
    print("Client selected")
    print(self.client)
    if hovered_tag ~= self.origin_tag then
        print("Moving client below to hovered_tag")
        print(self.client)
        print("Printing self.hovered_tag")
        self.client:move_to_tag(self.hovered_tag)
    end

    -- Disconnect from the "button::release" signal
    --self.wibox:disconnect_signal("mouse::release", function() self:drop() end)
end

return DragonDrop
