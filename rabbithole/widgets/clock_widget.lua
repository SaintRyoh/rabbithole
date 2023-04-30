local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local systrayWidget = require("rabbithole.widgets.wonderland.systray_widget")

local clockWidget = {}


function clockWidget.new(args)
    local self = {}
    setmetatable(self, { __index = clockWidget })

    self.widget = self:createWidget(args)

    self.widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            self:toggleSystrayPopup()
        end)
    ))

    return self
end

function clockWidget:createWidget(args)
    local widget = wibox.widget.textclock()

    widget.font = beautiful.clock_font or "Ubuntu 8"
    widget.align = "center"
    widget.valign = "center"
    widget.markup = widget.text

    local dpi = require("beautiful.xresources").apply_dpi
    widget.left = dpi(2)
    widget.right = dpi(2)

    return widget
end


function clockWidget:toggleSystrayPopup()
    local s = mouse.screen
    local systrayPopup = s.systrayPopup

    if not systrayPopup then
        systrayPopup = systrayWidget.new()
        systrayPopup.popup.visible = false
        s.systrayPopup = systrayPopup
    end

    if systrayPopup.popup.visible then
        systrayPopup.popup.visible = false
    else
        -- Set the position of the systrayPopup
        local x = s.geometry.width - systrayPopup.popup.width - 30  -- Set x position to the right of the screen with 30px margin
        local y = beautiful.wibar_height + 30  -- Set y position to 30px below the top of the wibar
        systrayPopup.popup:move_next_to(mouse.current_widget.geometry, "br")  -- Position the popup next to the clock widget

        systrayPopup.popup.visible = true
    end
end


return clockWidget
