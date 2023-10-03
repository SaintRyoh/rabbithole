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

function NotificationCenter.new(
    rabbithole__services__notificationCenter__notification,
    rabbithole__services__notificationCenter__logger,
    rabbithole__services__notificationCenter__balloon
)
    local self = setmetatable({ }, NotificationCenter)

    self.notification = rabbithole__services__notificationCenter__notification
    self.logger = rabbithole__services__notificationCenter__logger
    self.balloon = rabbithole__services__notificationCenter__balloon
    -- Notifications queue
    self.notifications = {}

    return self
end

function NotificationCenter:showNotification(title, message)
    local notification = self.notification.new()
    notification:title(title)
    notification:setMessage(message)

    -- Add the new notification to the list of notifications
    table.insert(self.notifications, notification)

    return notification
end

-- send client to the urgent notification by clicking the notification baloon
function NotificationCenter:onClick(client_notification)
    local client = client_notification.client
    local tag = client_notification.tag

    tag:view_only()

    client:emit_signal('request::activate', 'notification_center', { raise = true })
end

return NotificationCenter
