-- DragonDrop is a service that allows you to drag clients between tags.
-- It is used in rabbithole/components/buttons/tasklist.lua to allow you to
-- drag clients between tags from the tasklist widget.

local DragonDrop = {}
DragonDrop.__index = DragonDrop

function DragonDrop.new()
    local self = setmetatable({}, DragonDrop)

    self.client = nil
    self.origin_tag = nil
    self.initial_minimized_state = nil

    return self
end

function DragonDrop:drag(client, origin_tag)
    self.client = client
    self.origin_tag = origin_tag
    self.initial_minimized_state = client.minimized
end

function DragonDrop:drop(hovered_tag)
    if self.client then
        if hovered_tag == self.origin_tag then
            if self.initial_minimized_state then
                self.client.minimized = false
            else
                self.client.minimized = true
            end
        else
            self.client:move_to_tag(hovered_tag)
        end
    end

    self.client = nil
    self.origin_tag = nil
    self.initial_minimized_state = nil
end

return DragonDrop
