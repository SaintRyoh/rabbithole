-- DragonDrop is a service that allows you to drag clients between tags.
-- It is used in rabbithole/components/buttons/tasklist.lua to allow you to
-- drag clients between tags in the tasklist.

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
    -- popup widget, taglist widget
    self.wibox = mouse.current_widgets[1]
    print("LOOK OVER HERE")
    print(self.wibox)
    self.wibox:connect_signal("button::release", function() self:drop() end)
end

function DragonDrop:drop()
    print("The mouse button has been released.")
    local tag_under_pointer = mouse.object_under_pointer()
    print(tag_under_pointer)
    if tag_under_pointer ~= self.og_tag then
        self.client:move_to_tag(tag_under_pointer)
    end

    -- Disconnect from the "button::release" signal
    self.wibox:disconnect_signal("button::release", function() self:drop() end)
end

return DragonDrop
