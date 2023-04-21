local Widget = require("elements-base-ui") -- Make sure the path is correct
local Animations = require("elements-animations") -- Make sure the path is correct

--[[ Usage:
local my_popup = Popup({
    width = 200,
    height = 100,
    bg = "#ffffff",
    border_color = "#000000",
    border_width = 1,
    position = "bottom_right",
    animation = "slide_in",
    animation_duration = 250
})

-- Add content to the popup
my_popup.popup:setup {
    {
        {
            text = "This is a popup!",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        },
        margins = 10,
        widget = wibox.container.margin
    },
    widget = wibox.container.background
}

-- Show the popup
my_popup:show()

-- You can use a timer or any event to hide the popup after

]]

local Popup = class(Widget)

function Popup:init(args)
    args = args or {}
    self.width = args.width or 200
    self.height = args.height or 100
    self.bg = args.bg or "#ffffff"
    self.border_color = args.border_color or "#000000"
    self.border_width = args.border_width or 1
    self.position = args.position or "bottom_right"
    self.animation = args.animation or "slide_in"
    self.animation_duration = args.animation_duration or 250

    -- Create a wibox for the popup
    self.popup = wibox({
        ontop = true,
        visible = false,
        width = self.width,
        height = self.height,
        bg = self.bg,
        border_color = self.border_color,
        border_width = self.border_width,
        shape = gears.shape.rounded_rect
    })

    -- Set the position of the popup
    self:set_position(self.position)

    -- Initialize the animations class
    self.animations = Animations()
end

function Popup:set_position(position)
    local s = awful.screen.focused()
    local x, y

    if position == "bottom_right" then
        x = s.geometry.x + s.geometry.width - self.width
        y = s.geometry.y + s.geometry.height - self.height
    -- Add other positions here
    else
        x = s.geometry.x + s.geometry.width / 2 - self.width / 2
        y = s.geometry.y + s.geometry.height / 2 - self.height / 2
    end

    self.popup.x = x
    self.popup.y = y
end

function Popup:show()
    if not self.popup.visible then
        self.popup.visible = true
        if self.animation == "slide_in" then
            self.animations:slideIn(self.popup, self.animation_duration, self.position)
        end
    end
end

function Popup:hide()
    if self.popup.visible then
        if self.animation == "slide_in" then
            self.animations:slideOut(self.popup, self.animation_duration, self.position, function()
                self.popup.visible = false
            end)
        else
            self.popup.visible = false
        end
    end
end

