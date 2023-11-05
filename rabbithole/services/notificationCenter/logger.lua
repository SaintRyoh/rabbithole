-- notification_logger.lua

local NotificationLogger = {}

function NotificationLogger.new()
    local self = {}

    function self.log(notification)
        print("Logging CTA:", notification)
        -- Implement your own logging logic here (e.g., writing to a file or sending to a remote server)
    end

    return self
end

return NotificationLogger