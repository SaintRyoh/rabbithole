local class = require("src.modules.class") -- Make sure to point to the correct path of your class file
local gears = require("gears")

local Animations = class()

function Animations:init()
    -- Nothing to initialize here
end

-- fadeIn
function Animations:fadeIn(widget, duration, callback)
    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local opacity = widget.opacity or 1
            opacity = opacity + 0.01

            if opacity >= 1 then
                timer:stop()
                widget.opacity = 1

                if callback then
                    callback()
                end
            else
                widget.opacity = opacity
            end
        end
    }
end

-- fadeOut
function Animations:fadeOut(widget, duration, callback)
    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local opacity = widget.opacity or 1
            opacity = opacity - 0.01

            if opacity <= 0 then
                timer:stop()
                widget.opacity = 0

                if callback then
                    callback()
                end
            else
                widget.opacity = opacity
            end
        end
    }
end

-- scale
function Animations:scale(widget, duration, from_scale, to_scale, callback)
    local steps = duration / 10
    local delta = (to_scale - from_scale) / steps

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            local current_scale = widget.scale or from_scale
            current_scale = current_scale + delta

            if (delta > 0 and current_scale >= to_scale) or (delta < 0 and current_scale <= to_scale) then
                timer:stop()
                widget.scale = to_scale

                if callback then
                    callback()
                end
            else
                widget.scale = current_scale
            end
        end
    }
end

-- translate
function Animations:translate(widget, duration, from_x, from_y, to_x, to_y, callback)
    local steps = duration / 10
    local delta_x = (to_x - from_x) / steps
    local delta_y = (to_y - from_y) / steps

    widget.x = from_x
    widget.y = from_y

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            local current_x = widget.x
            local current_y = widget.y

            current_x = current_x + delta_x
            current_y = current_y + delta_y

            if (delta_x > 0 and current_x >= to_x) or (delta_x < 0 and current_x <= to_x) then
                current_x = to_x
            end

            if (delta_y > 0 and current_y >= to_y) or (delta_y < 0 and current_y <= to_y) then
                current_y = to_y
            end

            widget.x = current_x
            widget.y = current_y

            if current_x == to_x and current_y == to_y then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

-- rotate
function Animations:rotate(widget, duration, from_angle, to_angle, callback)
    local steps = duration / 10
    local delta = (to_angle - from_angle) / steps

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            local current_angle = widget.angle or from_angle
            current_angle = current_angle + delta

            if (delta > 0 and current_angle >= to_angle) or (delta < 0 and current_angle <= to_angle) then
                timer:stop()
                widget.angle = to_angle

                if callback then
                    callback()
                end
            else
                widget.angle = current_angle
            end
        end
    }
end

return Animations
