-- This is a popup container that holds a widget. This is going to be used as
-- the container for the dropdown terminal, dropdown file manager, and quick notes.
-- The popup container is a wibox that drops down from the top of the screen.
-- It is used to hold widgets that are toggled on and off.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi


local DropdownContainer = {}
DropdownContainer.__index = DropdownContainer


function DropdownContainer:new(program, args)
    setmetatable({}, self)

    self.program = program
    self.args = args
    self.visible = false
    self:setup()

    return self
end

-- Popup dropdown container wrapper
function DropdownContainer:create()
    self.popup = awful.popup {
        widget = {
            {
                {
                    self.program, -- Replace with your terminal emulator's command
                    widget = wibox.widget.textbox
                },
                margins = dpi(4),
                widget = wibox.container.margin
            },
            widget = wibox.container.background
        },
        visible = false,
        ontop = true,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, dpi(6))
        end,
    }
end

-- toggle visibility
function DropdownContainer:toggle()
    self.visible = not self.visible
    self.popup.visible = self.visible
end

-- initialist the popup
function DropdownContainer:setup()
    self:create()
    self:toggle()
end

return DropdownContainer