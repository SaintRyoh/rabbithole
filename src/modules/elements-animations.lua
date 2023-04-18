local class = require("src.modules.class") -- Make sure to point to the correct path of your class file
local gears = require("gears")

--[[ Usage:
local anim = Animations()

-- Apply elevation animation
anim:elevation(myWidget, 1, 0, 5, function()
    print("Elevation completed!")
end)

-- Apply shape transformation animation
local from_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
end

local to_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 30)
end

anim:shapeTransformation(myWidget, 1, from_shape, to_shape, function()
    print("Shape transformation completed!")
end)
]]

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

function Animations:elevation(widget, duration, from_elevation, to_elevation, callback)
    local steps = duration / 10
    local delta = (to_elevation - from_elevation) / steps

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            local current_elevation = widget.elevation or from_elevation
            current_elevation = current_elevation + delta

            if (delta > 0 and current_elevation >= to_elevation) or (delta < 0 and current_elevation <= to_elevation) then
                timer:stop()
                widget.elevation = to_elevation

                if callback then
                    callback()
                end
            else
                widget.elevation = current_elevation
            end
        end
    }
end

function Animations:shapeTransformation(widget, duration, from_shape, to_shape, callback)
    local steps = duration / 10
    local progress = 0

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)

            if progress >= 1 then
                timer:stop()
                widget.shape = to_shape

                if callback then
                    callback()
                end
            else
                widget.shape = function(cr, width, height)
                    local function lerp(a, b, t)
                        return a + (b - a) * t
                    end

                    local from_extents = from_shape(cr, width, height)
                    local to_extents = to_shape(cr, width, height)

                    local result_extents = {}
                    for i = 1, #from_extents do
                        table.insert(result_extents, lerp(from_extents[i], to_extents[i], progress))
                    end

                    cr:move_to(result_extents[1], result_extents[2])
                    for i = 3, #result_extents, 2 do
                        cr:line_to(result_extents[i], result_extents[i + 1])
                    end
                    cr:close_path()
                end
            end
        end
    }
end

function Animations:colorTransition(widget, duration, from_color, to_color, callback)
    local steps = duration / 10
    local delta_r = (to_color.red - from_color.red) / steps
    local delta_g = (to_color.green - from_color.green) / steps
    local delta_b = (to_color.blue - from_color.blue) / steps
    local delta_a = (to_color.alpha - from_color.alpha) / steps

    local current_color = from_color

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            current_color.red = current_color.red + delta_r
            current_color.green = current_color.green + delta_g
            current_color.blue = current_color.blue + delta_b
            current_color.alpha = current_color.alpha + delta_a

            if (delta_r > 0 and current_color.red >= to_color.red) or (delta_r < 0 and current_color.red <= to_color.red) then
                current_color.red = to_color.red
            end

            if (delta_g > 0 and current_color.green >= to_color.green) or (delta_g < 0 and current_color.green <= to_color.green) then
                current_color.green = to_color.green
            end

            if (delta_b > 0 and current_color.blue >= to_color.blue) or (delta_b < 0 and current_color.blue <= to_color.blue) then
                current_color.blue = to_color.blue
            end

            if (delta_a > 0 and current_color.alpha >= to_color.alpha) or (delta_a < 0 and current_color.alpha <= to_color.alpha) then
                current_color.alpha = to_color.alpha
            end

            widget:set_fg(gears.color(current_color))

            if current_color.red == to_color.red and current_color.green == to_color.green and current_color.blue == to_color.blue and current_color.alpha == to_color.alpha then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:positionSizeTransition(widget, duration, from_x, from_y, from_width, from_height, to_x, to_y, to_width, to_height, callback)
    local steps = duration / 10
    local delta_x = (to_x - from_x) / steps
    local delta_y = (to_y - from_y) / steps
    local delta_width = (to_width - from_width) / steps
    local delta_height = (to_height - from_height) / steps

    widget.x = from_x
    widget.y = from_y
    widget.width = from_width
    widget.height = from_height

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            widget.x = widget.x + delta_x
            widget.y = widget.y + delta_y
            widget.width = widget.width + delta_width
            widget.height = widget.height + delta_height

            if (delta_x > 0 and widget.x >= to_x) or (delta_x < 0 and widget.x <= to_x) then
                widget.x = to_x
            end

            if (delta_y > 0 and widget.y >= to_y) or (delta_y < 0 and widget.y <= to_y) then
                widget.y = to_y
            end

            if (delta_width > 0 and widget.width >= to_width) or (delta_width < 0 and widget.width <= to_width) then
                widget.width = to_width
            end

            if (delta_height > 0 and widget.height >= to_height) or (delta_height < 0 and widget.height <= to_height) then
                widget.height = to_height
            end

            if widget.x == to_x and widget.y == to_y and widget.width == to_width and widget.height == to_height then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:rotationTransition(widget, duration, from_angle, to_angle, callback)
    local steps = duration / 10
    local delta_angle = (to_angle - from_angle) / steps
    local current_angle = from_angle

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            current_angle = current_angle + delta_angle

            if (delta_angle > 0 and current_angle >= to_angle) or (delta_angle < 0 and current_angle <= to_angle) then
                current_angle = to_angle
            end

            widget:set_rotate(current_angle)

            if current_angle == to_angle then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:scaleTransition(widget, duration, from_scale_x, from_scale_y, to_scale_x, to_scale_y, callback)
    local steps = duration / 10
    local delta_scale_x = (to_scale_x - from_scale_x) / steps
    local delta_scale_y = (to_scale_y - from_scale_y) / steps
    local current_scale_x = from_scale_x
    local current_scale_y = from_scale_y

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            current_scale_x = current_scale_x + delta_scale_x
            current_scale_y = current_scale_y + delta_scale_y

            if (delta_scale_x > 0 and current_scale_x >= to_scale_x) or (delta_scale_x < 0 and current_scale_x <= to_scale_x) then
                current_scale_x = to_scale_x
            end

            if (delta_scale_y > 0 and current_scale_y >= to_scale_y) or (delta_scale_y < 0 and current_scale_y <= to_scale_y) then
                current_scale_y = to_scale_y
            end

            widget:set_scale(current_scale_x, current_scale_y)

            if current_scale_x == to_scale_x and current_scale_y == to_scale_y then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:acceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
    local steps = duration / 10
    local progress = 0

    widget.x = from_x
    widget.y = from_y

    local function in_quad(t)
        return t * t
    end

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local eased_progress = in_quad(progress)

            widget.x = from_x + (to_x - from_x) * eased_progress
            widget.y = from_y + (to_y - from_y) * eased_progress

            if progress >= 1 then
                timer:stop()
                widget.x = to_x
                widget.y = to_y

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:deceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
    local steps = duration / 10
    local progress = 0

    widget.x = from_x
    widget.y = from_y

    local function out_quad(t)
        return t * (2 - t)
    end

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local eased_progress = out_quad(progress)

            widget.x = from_x + (to_x - from_x) * eased_progress
            widget.y = from_y + (to_y - from_y) * eased_progress

            if progress >= 1 then
                timer:stop()
                widget.x = to_x
                widget.y = to_y

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:acceleratedDeceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
    local steps = duration / 10
    local progress = 0

    widget.x = from_x
    widget.y = from_y

    local function in_out_quad(t)
        t = t * 2
        if t < 1 then
            return 0.5 * t * t
        else
            t = t - 1
            return -0.5 * (t * (t - 2) - 1)
        end
    end

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local eased_progress = in_out_quad(progress)

            widget.x = from_x + (to_x - from_x) * eased_progress
            widget.y = from_y + (to_y - from_y) * eased_progress

            if progress >= 1 then
                timer:stop()
                widget.x = to_x
                widget.y = to_y

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:bounceEffect(widget, duration, height, callback)
    local steps = duration / 10
    local progress = 0
    local from_y = widget.y

    local function out_bounce(t)
        if t < 1 / 2.75 then
            return 7.5625 * t * t
        elseif t < 2 / 2.75 then
            t = t - 1.5 / 2.75
            return 7.5625 * t * t + 0.75
        elseif t < 2.5 / 2.75 then
            t = t - 2.25 / 2.75
            return 7.5625 * t * t + 0.9375
        else
            t = t - 2.625 / 2.75
            return 7.5625 * t * t + 0.984375
        end
    end

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local eased_progress = out_bounce(progress)

            widget.y = from_y - height * eased_progress

            if progress >= 1 then
                timer:stop()
                widget.y = from_y

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:cornerRadiusTransition(widget, duration, from_radius, to_radius, callback)
    local steps = duration / 10
    local delta_radius = (to_radius - from_radius) / steps
    local current_radius = from_radius

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            current_radius = current_radius + delta_radius

            if (delta_radius > 0 and current_radius >= to_radius) or (delta_radius < 0 and current_radius <= to_radius) then
                current_radius = to_radius
            end

            widget.shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, current_radius)
            end

            if current_radius == to_radius then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

--[[ Usage:
local anim = Animations()

-- Apply emphasized animation
anim:emphasized(myWidget, nil, 0, 0, 100, 100, function()
    print("Emphasized animation completed!")
end)

-- Apply emphasized decelerate animation
anim:emphasizedDecelerate(myWidget, nil, 0, 0, 100, 100, function()
    print("Emphasized decelerate animation completed!")
end)


]]


function Animations:emphasized(widget, duration, from_x, from_y, to_x, to_y, callback)
    duration = duration or 0.5
    self:acceleratedDeceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
end

function Animations:emphasizedDecelerate(widget, duration, from_x, from_y, to_x, to_y, callback)
    duration = duration or 0.4
    self:deceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
end

function Animations:emphasizedAccelerate(widget, duration, from_x, from_y, to_x, to_y, callback)
    duration = duration or 0.2
    self:acceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
end

function Animations:standard(widget, duration, from_x, from_y, to_x, to_y, callback)
    duration = duration or 0.3
    self:acceleratedDeceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
end

function Animations:standardDecelerate(widget, duration, from_x, from_y, to_x, to_y, callback)
    duration = duration or 0.25
    self:deceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
end

function Animations:standardAccelerate(widget, duration, from_x, from_y, to_x, to_y, callback)
    duration = duration or 0.2
    self:acceleratedMovement(widget, duration, from_x, from_y, to_x, to_y, callback)
end


return Animations
