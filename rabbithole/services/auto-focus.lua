local AutoFocus = {}
AutoFocus.__index = AutoFocus

function AutoFocus.new()
    local self = setmetatable({}, AutoFocus)

    require("awful.autofocus")

    return self
end

return AutoFocus