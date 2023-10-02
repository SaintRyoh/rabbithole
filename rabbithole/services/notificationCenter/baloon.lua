-- Notification balloon component

local NotificationBalloon = {}
NotificationBalloon.__index = NotificationBalloon


function NotificationBalloon.new()
    local self = {}

    function self.show(notification)
        print("Showing notification balloon:", notification)
        -- Implement your own logic to display the notification balloon (e.g., using an external library or widget)

        -- Simulate clicking on the balloon to open client
        self.onClick(notification)
    end

    function self.onClick(notification)
        -- Handle the click event to open the urgent client
        NotificationService.openClient(notification)
    end

    return self
end

return NotificationBalloon