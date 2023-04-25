local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local wifiHotspot = {}


function wifiHotspot.new(args)
    local self = {}
    setmetatable(self, { __index = wifiHotspot })

    self.widget = self:createWidget(args)
    self.isHotspotEnabled = false

    self.widget:connect_signal("button::press", function()
        self:toggleHotspot()
    end)

    self:updateHotspotStatus()

    return self
end

function wifiHotspot:createWidget(args)
    local widget = wibox.widget.imagebox()
    widget.resize = false
    return widget
end

function wifiHotspot:toggleHotspot()
    self.isHotspotEnabled = not self.isHotspotEnabled
    self:updateHotspotStatus()

    if self.isHotspotEnabled then
        awful.spawn("nmcli dev wifi hotspot ifname wlan0 ssid MyHotspot password mypassword")
    else
        awful.spawn("nmcli radio wifi off && sleep 1 && nmcli radio wifi on")
    end
end

function wifiHotspot:updateHotspotStatus()
    local icon_path = beautiful.wifi_hotspot_icon_path or "themes/rabbithole/icons/wifi_hotspot/"

    if self.isHotspotEnabled then
        self.widget.image = icon_path .. "hotspot-on.svg"
    else
        self.widget.image = icon_path .. "hotspot-off.svg"
    end
end

return wifiHotspot
