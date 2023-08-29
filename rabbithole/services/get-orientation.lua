-- This service takes a widget as an argument, then determines what 
-- orientation it is in.

local getOrientation = {}
getOrientation.__index = getOrientation

function getOrientation.new()
    local self = setmetatable({}, getOrientation)
    return self
end

function getOrientation:orientation_is(widget)
    local width = widget.width or widget._private.width
    local height = widget.height or widget._private.height

    if width and height then
        if width > height then
            return "horizontal"
        else
            return "vertical"
        end
    else
        return "unknown" -- Unable to determine orientation
    end
end

return getOrientation
