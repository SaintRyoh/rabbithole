-- This service takes a wibox or a widgeobjt as an argument, then determines what 
-- orientation it is in.

local WiDetect = { }
WiDetect.__index = WiDetect

function WiDetect.new()
    local self = setmetatable({ }, WiDetect)

    return self
end

function WiDetect:orientation_is(obj)
    local width = obj.width
    local height = obj.height

    if width and height then
        if width > height then
            return "horizontal"
        else
            return "vertical"
        end
    else
        return "Apparently you have passed a zero-point object, cause it has no height or width dude" -- Unable to determine what the fuck kind of object you are passing
    end
end

return WiDetect
