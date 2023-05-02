local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

local notificationToggle = {}


function notificationToggle.new(args)
    local self = {}
    setmetatable(self, { __index = notificationToggle })

    self.widget = self:createWidget(args)

    self.widget:connect_signal("button::press", function()
        self:toggleNotifications()
    end)

    self:updateNotificationStatus()

    return self
end

function notificationToggle:createWidget(args)
    local widget = wibox.widget.imagebox()
    widget.resize = false
    return widget
end

function notificationToggle:toggleNotifications()
    naughty.suspended = not naughty.suspended
    self:updateNotificationStatus()
end

function notificationToggle:updateNotificationStatus()
    local icon_path = beautiful.notification_icon_path or "themes/rabbithole/icons/notifications/"

    if naughty.suspended then
        self.widget.image = icon_path .. "notifications-off.svg"
    else
        self.widget.image = icon_path .. "notifications-on.svg"
    end
end

return notificationToggle
