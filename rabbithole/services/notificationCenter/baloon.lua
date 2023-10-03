-- Notification balloon component

local NotificationBalloon = {}
NotificationBalloon.__index = NotificationBalloon


function NotificationBalloon.new(NotificationService)
    local self = {}

    function self.show(notification)
        print("Showing notification balloon:", notification)

        self.onClick(notification)
    end

    function self.onClick(notification)
        NotificationService.openClient(notification)
    end

    return self
end

return NotificationBalloon