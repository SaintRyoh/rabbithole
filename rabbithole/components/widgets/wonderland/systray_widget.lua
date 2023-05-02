local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

-- define csystray object
local systrayPopup = {}


function systrayPopup.new(args)
    local self = {}
    setmetatable(self, { __index = systrayPopup })

    self.popup = self:create_popup()

    return self
end

function systrayPopup:create_popup()
    local test_textbox = wibox.widget {
        text   = "This is gonna be where wonderlands icons get fed into",
        widget = wibox.widget.textbox
    }

    local popup = awful.popup {
        widget = {
            test_textbox,
            layout = wibox.layout.fixed.horizontal
        },
        visible = false,
        ontop = true,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_normal,
        border_color = beautiful.border_normal,
        border_width = beautiful.border_width,
        width = 200,
        height = 100
    }

    -- Set the position of the popup widget
    local dpi = require("beautiful").xresources.apply_dpi
    local s = awful.screen.focused()
    local x = s.geometry.width - popup.width - dpi(30)  -- Set x position to the right of the screen with 30px margin
    local y = dpi(30)  -- Set y position to 30px below the top of the wibar
    popup.x = x
    popup.y = y

    return popup
end


function systrayPopup:toggle()
    self.popup.visible = not self.popup.visible
end

return systrayPopup
