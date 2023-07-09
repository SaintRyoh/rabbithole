-- DragonDrop is a service that allows you to drag clients between tags.
-- It is used in rabbithole/components/buttons/tasklist.lua to allow you to
-- drag clients between tags from the tasklist widget.

local DragonDrop = {}
DragonDrop.__index = DragonDrop

function DragonDrop.new()
    local self = setmetatable({ }, DragonDrop)

    self.og_tag = nil
    self.client = nil
    self.hovered_tag = nil

    return self
end

function DragonDrop:drag(client, origin_tag)
    self.client = client
    self.origin_tag = origin_tag
    --self.hovered_tag = hovered_tag
    print("INSIDE DRAG FUNCTION:\nPrinting client, origin_tag, hovered_tag passed to function.")
    print(self.client)
    print(self.origin_tag)
    --print(self.hovered_tag)
end

function DragonDrop:drop(client, hovered_tag)
    print("Inside drop() of dragndrop module...\nPrinting hovered_tag passed to drop()")
    print(hovered_tag)
    self.hovered_tag = hovered_tag
    --self.client = client
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
