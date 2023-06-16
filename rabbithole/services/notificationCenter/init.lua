--[[ Notification Center Service

The notification center service is responsible for managing notifications. It
is a singleton service, meaning that there is only one instance of it. It is
accessible from any other service or widget.

Eventually, the plan is to have a notification center widget that allows you to
switch to clients in a FIFO (first in, first out) manner. This is useful for
notifications that are not urgent, but you want to get to eventually. For
example, a notification that a download has completed.
]]

local NotificationCenter = {}
NotificationCenter.__index = NotificationCenter

function NotificationCenter.new(rabbithole__services__notificationCenter___notification)
    local self = setmetatable({ }, NotificationCenter)

    self.notification = rabbithole__services__notificationCenter___notification
    -- Notifications queue
    self.notifications = {}

    return self
end

function NotificationCenter:createNotification(title, message)
    local notification = self.notification.new()
    notification:title(title)
    notification:setMessage(message)

    -- Add the new notification to the list of notifications
    table.insert(self.notifications, notification)

    return notification
end

return NotificationCenter
