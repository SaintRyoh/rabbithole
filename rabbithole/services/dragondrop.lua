local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local DragonDrop = {}
DragonDrop.__index = DragonDrop

function DragonDrop.new()
    local self = setmetatable({}, DragonDrop)

    self.icon_wibox = nil

    return self
end

function DragonDrop:drag(c)
    local icon = wibox.widget.imagebox()
    self.icon_wibox = wibox({ type = "normal", visible = false })
    self.icon_wibox:set_widget(icon)

    icon:set_image(c.icon)
    self.icon_wibox.visible = true

    client.connect_signal("mouse::move", function ()
        self.icon_wibox.x = mouse.coords().x
        self.icon_wibox.y = mouse.coords().y
    end)
end

function DragonDrop:drop(c)
    if self.icon_wibox then
        self.icon_wibox.visible = false
        local tag_under_pointer = mouse.object_under_pointer()
        if tag_under_pointer and tag_under_pointer ~= c.first_tag then
            c:move_to_tag(tag_under_pointer)
        end
    end
end

return DragonDrop