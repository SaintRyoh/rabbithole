-- DragonDrop is a service that allows you to drag clients between tags.
-- It is used in rabbithole/components/buttons/tasklist.lua to allow you to
-- drag clients between tags from the tasklist widget.

local DragonDrop = {}
DragonDrop.__index = DragonDrop

function DragonDrop.new()
    local self = setmetatable({ }, DragonDrop)

    self.client = nil
    self.hovered_tag = nil

    return self
end

function DragonDrop:drag(client, origin_tag)
    self.client = client
    self.origin_tag = origin_tag
end

function DragonDrop:drop(hovered_tag)
    self.hovered_tag = hovered_tag

    if self.hovered_tag ~= self.origin_tag then
        if self.client then
            self.client:move_to_tag(self.hovered_tag)
        end
    end

    self.client = nil -- reset
    self.hovered_tag = nil
end

return DragonDrop
