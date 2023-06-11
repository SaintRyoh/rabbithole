local Notification = { }
Notification.__index = Notification

function Notification.new()
    local self = setmetatable({ }, Notification)

    -- Notification properties
    self.title = "" or "Notification"
    self.message = "" or "This is a notification. About what? I don't know."

    return self
end

function Notification:setTitle(title)
    self.title = title
end

function Notification:setMessage(message)
    self.message = message
end

-- Define other necessary methods here...

return Notification