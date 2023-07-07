-- DragonDrop is a service that allows you to drag clients between tags.
-- It is used in rabbithole/components/buttons/tasklist.lua to allow you to
-- drag clients between tags in the tasklist.

local awful = require("awful")
local gears = require("gears")

local DragonDrop = {}
DragonDrop.__index = DragonDrop

function DragonDrop.new()
    local self = setmetatable({}, DragonDrop)

    self.og_tag = nil
    self.client = nil

    return self
end

function DragonDrop:drag(c)
    self.client = c
    print(self.client)
    self.og_tag = c.first_tag
    print(self.og_tag)
    print("The mouse button is being held.")

    -- Connect to the "mouse::release" signal
    self.client:connect_signal("button::release", self:drop())
end

function DragonDrop:drop()
    print("The mouse button has been released.")
    local tag_under_pointer = mouse.object_under_pointer()
    if tag_under_pointer ~= self.og_tag then
        self.client:move_to_tag(tag_under_pointer)
    end

    -- Disconnect from the "mouse::release" signal
    self.client:disconnect_signal("button::release", self:drop())
end

return DragonDrop
