local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

-- update this shit when i know the popup is working
--local volumeSlider = require("../volumeSlider")
--local brightnessSlider = require("../brightnessSlider")
--local clockWidget = require("../clockWidget")
--local calendarWidget = require("../calendarWidget")
--local batteryWidget = require("../batteryWidget")
--local networkWidget = require("../networkWidget")
--local vpnWidget = require("../vpnWidget")
--local screenCaptureWidget = require("../screenCaptureWidget")
--local notificationWidget = require("../notificationWidget")
--local wifiHotspotWidget = require("../wifiHotspotWidget")
--local volumeIconWidget = require("../volumeIconWidget")

local systrayPopup = {}

function systrayPopup.new(args)
    local self = {}
    setmetatable(self, { __index = systrayPopup })

    -- Comment out or remove the other widgets
    -- self.widgets = {
    --     volumeSlider.new(),
    --     brightnessSlider.new(),
    --     clockWidget.new(),
    --     calendarWidget.new(),
    --     batteryWidget.new(),
    --     networkWidget.new(),
    --     vpnWidget.new(),
    --     screenCaptureWidget.new(),
    --     notificationWidget.new(),
    --     wifiHotspotWidget.new(),
    --     volumeIconWidget.new(),
    -- }

    self.popup = self:create_popup()

    return self
end

function systrayPopup:create_popup()
    local popup = awful.popup {
        widget = {
            -- The popup will be empty for now
            layout = wibox.layout.fixed.horizontal
        },
        visible = false,
        ontop = true,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_normal,
        border_color = beautiful.border_normal,
        border_width = beautiful.border_width
    }

    -- Attach the popup to the clock widget
    awful.placement.top(popup, { margins = { top = 30 }, parent = awful.screen.focused() })

    return popup
end

function systrayPopup:toggle()
    self.popup.visible = not self.popup.visible
end

return systrayPopup
