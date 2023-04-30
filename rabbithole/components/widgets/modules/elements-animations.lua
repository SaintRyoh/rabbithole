local class = require("src.modules.class") -- Make sure to point to the correct path of your class file
local gears = require("gears")

--[[ 
Material Design 3 Standards:

Purposeful: Ensure that animations serve a purpose, such as providing feedback, focusing attention, or revealing elements. Avoid animations that don't add value to the user experience.

Smooth: Make sure that animations are fluid and smooth by using easing functions and appropriate durations.

Consistent: Maintain consistency throughout your application by using a predefined set of animations or motion patterns. 

Usage:

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

-- OR --c

Animations:

local animations = Animations()
local myWidget = Widget()

myWidget:addAnimation(animations.fadeIn, 1, function()
    print("Fade-in animation completed!")
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

function Animations:scaleIn(widget, duration, from_scale, to_scale, callback)
    duration = duration or 0.25
    local steps = duration / 0.01
    local progress = 0
    from_scale = from_scale or 0
    to_scale = to_scale or 1

    widget:set_forced_height(widget.height * from_scale)
    widget:set_forced_width(widget.width * from_scale)

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local scale = from_scale + (to_scale - from_scale) * progress

            widget:set_forced_height(widget.height * scale)
            widget:set_forced_width(widget.width * scale)

            if progress >= 1 then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:scaleOut(widget, duration, from_scale, to_scale, callback)
    duration = duration or 0.25
    local steps = duration / 0.01
    local progress = 0
    from_scale = from_scale or 1
    to_scale = to_scale or 0

    widget:set_forced_height(widget.height * from_scale)
    widget:set_forced_width(widget.width * from_scale)

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local scale = from_scale + (to_scale - from_scale) * progress

            widget:set_forced_height(widget.height * scale)
            widget:set_forced_width(widget.width * scale)

            if progress >= 1 then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:rotateIn(widget, duration, from_angle, to_angle, callback)
    duration = duration or 0.5
    local steps = duration / 0.01
    local progress = 0
    from_angle = from_angle or 0
    to_angle = to_angle or 360

    widget.rotation = math.rad(from_angle)

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local angle = from_angle + (to_angle - from_angle) * progress

            widget.rotation = math.rad(angle)

            if progress >= 1 then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:rotateOut(widget, duration, from_angle, to_angle, callback)
    duration = duration or 0.5
    local steps = duration / 0.01
    local progress = 0
    from_angle = from_angle or 0
    to_angle = to_angle or -360

    widget.rotation = math.rad(from_angle)

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local angle = from_angle + (to_angle - from_angle) * progress

            widget.rotation = math.rad(angle)

            if progress >= 1 then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:slideIn(widget, direction, duration, distance, callback)
    duration = duration or 0.3
    direction = direction or "left"
    distance = distance or 100

    local original_x = widget.x
    local original_y = widget.y

    if direction == "left" then
        widget.x = original_x - distance
    elseif direction == "right" then
        widget.x = original_x + distance
    elseif direction == "up" then
        widget.y = original_y - distance
    elseif direction == "down" then
        widget.y = original_y + distance
    end

    self:positionChange(widget, original_x, original_y, duration, "outCubic", callback)
end

function Animations:slideOut(widget, direction, duration, distance, callback)
    duration = duration or 0.3
    direction = direction or "left"
    distance = distance or 100

    local target_x = widget.x
    local target_y = widget.y

    if direction == "left" then
        target_x = target_x - distance
    elseif direction == "right" then
        target_x = target_x + distance
    elseif direction == "up" then
        target_y = target_y - distance
    elseif direction == "down" then
        target_y = target_y + distance
    end

    self:positionChange(widget, target_x, target_y, duration, "inCubic", callback)
end

function Animations:ripple(widget, x, y, duration, max_radius, callback)
    duration = duration or 0.3
    max_radius = max_radius or 50
    local progress = 0
    local steps = duration / 0.01

    local timer = gears.timer {
        timeout = 0.01,
        call_now = false,
        autostart = true,
        callback = function()
            progress = progress + (1 / steps)
            local radius = max_radius * progress

            widget:draw_ripple(x, y, radius)

            if progress >= 1 then
                timer:stop()

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:expand(widget, target_height, duration, callback)
    duration = duration or 0.3
    self:sizeChange(widget, nil, target_height, duration, "outCubic", callback)
end

function Animations:collapse(widget, target_height, duration, callback)
    duration = duration or 0.3
    self:sizeChange(widget, nil, target_height, duration, "inCubic", callback)
end

function Animations:staggered(widgets, animation, delay, ...)
    delay = delay or 0.1
    local current_delay = 0

    for _, widget in ipairs(widgets) do
        gears.timer.start_new(current_delay, function()
            animation(self, widget, ...)
        end)

        current_delay = current_delay + delay
    end
end

function Animations:flipIn(widget, duration, axis, callback)
    duration = duration or 0.3
    axis = axis or "y"

    local original_rotation
    if axis == "y" then
        original_rotation = widget.rotation_y
        widget.rotation_y = 90
    else
        original_rotation = widget.rotation_x
        widget.rotation_x = 90
    end

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (90 - (axis == "y" and widget.rotation_y or widget.rotation_x)) / 90
            local rotation = self.easing["outCubic"](progress, 90, -90, 1)

            if axis == "y" then
                widget.rotation_y = rotation
            else
                widget.rotation_x = rotation
            end

            if progress >= 1 then
                timer:stop()

                if axis == "y" then
                    widget.rotation_y = original_rotation
                else
                    widget.rotation_x = original_rotation
                end

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:flipOut(widget, duration, axis, callback)
    duration = duration or 0.3
    axis = axis or "y"

    local original_rotation
    if axis == "y" then
        original_rotation = widget.rotation_y
    else
        original_rotation = widget.rotation_x
    end

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = ((axis == "y" and widget.rotation_y or widget.rotation_x) - original_rotation) / 90
            local rotation = self.easing["inCubic"](progress, original_rotation, 90, 1)

            if axis == "y" then
                widget.rotation_y = rotation
            else
                widget.rotation_x = rotation
            end

            if progress >= 1 then
                timer:stop()

                if axis == "y" then
                    widget.rotation_y = original_rotation + 90
                else
                    widget.rotation_x = original_rotation + 90
                end

                if callback then
                    callback()
                end
            end
        end
    }
end


function Animations:bounceIn(widget, duration, intensity, callback)
    duration = duration or 0.5
    intensity = intensity or 30

    local original_y = widget.y
    widget.y = original_y - intensity

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (original_y - widget.y) / intensity
            widget.y = original_y + self.easing["outBounce"](progress, -intensity, intensity, 1)

            if progress >= 1 then
                timer:stop()
                widget.y = original_y

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:bounceOut(widget, duration, intensity, callback)
    duration = duration or 0.5
    intensity = intensity or 30

    local original_y = widget.y

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (widget.y - original_y) / intensity
            widget.y = original_y - self.easing["inBounce"](progress, 0, intensity, 1)

            if progress >= 1 then
                timer:stop()
                widget.y = original_y - intensity

                if callback then
                    callback()
                end
            end
        end
    }
end


function Animations:elasticIn(widget, duration, amplitude, period, callback)
    duration = duration or 0.5
    amplitude = amplitude or 1
    period = period or 0.3
    local original_y = widget.y
    widget.y = original_y + amplitude * 100

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (original_y - widget.y) / (amplitude * 100)
            widget.y = original_y + self.easing["inElastic"](progress, 0, amplitude * 100, 1, period)

            if progress >= 1 then
                timer:stop()
                widget.y = original_y

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:elasticOut(widget, duration, amplitude, period, callback)
    duration = duration or 0.5
    amplitude = amplitude or 1
    period = period or 0.3
    local original_y = widget.y

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (original_y - widget.y) / (amplitude * 100)
            widget.y = original_y - self.easing["outElastic"](progress, 0, amplitude * 100, 1, period)

            if progress >= 1 then
                timer:stop()
                widget.y = original_y - amplitude * 100

                if callback then
                    callback()
                end
            end
        end
    }
end

function Animations:shake(widget, duration, intensity, direction, callback)
    duration = duration or 0.3
    intensity = intensity or 10
    direction = direction or "horizontal"

    local original_x = widget.x
    local original_y = widget.y

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (widget.x - original_x) / (intensity * 2)
            local shake_value = self.easing["inOutSine"](progress, -intensity, intensity * 2, 1)

            if direction == "horizontal" then
                widget.x = original_x + shake_value
            else
                widget.y = original_y + shake_value
            end

            if progress >= 1 then
                timer:stop()

                if direction == "horizontal" then
                    widget.x = original_x
                else
                    widget.y = original_y
                end

                if callback then
                    callback()
                end
            end
        end
    }
end

--[[ Usage:
local awful = require("awful")
local wibox = require("wibox")
local Animations = require("elements-animations") -- Make sure the path is correct

-- Create a basic button widget
local button_widget = wibox.widget {
    {
        text = "Click me!",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    },
    shape = gears.shape.rounded_rect,
    bg = "#3f51b5", -- Change the color to your preference
    forced_width = 100,
    forced_height = 30,
    widget = wibox.container.background
}
--------------------------------------------------------------------------------
-- Create an instance of the Animations class
local animations = Animations()

-- Add hover elevation animation on mouse enter
button_widget:connect_signal("mouse::enter", function()
    animations:hoverElevation(button_widget, 0.3, 5)
end)

-- Remove hover elevation animation on mouse leave
button_widget:connect_signal("mouse::leave", function()
    animations:hoverElevation(button_widget, 0.3, -5)
end)

-- Add a click event to the button
button_widget:buttons(gears.table.join(
    awful.button({}, 1, nil, function()
        print("Button clicked!")
    end)
))

local button_widget = ShadowContainer {
    {
        {
            text = "Click me!",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        },
        shape = gears.shape.rounded_rect,
        bg = "#3f51b5", -- Change the color to your preference
        forced_width = 100,
        forced_height = 30,
        widget = wibox.container.background
    },
    shadow_color = "#000", -- Set the shadow color
    widget = ShadowContainer
}


]]

-- Shadow container
local ShadowContainer = {
    draw = function(self, context, cr, width, height)
        -- Draw shadow based on the elevation
        local elevation = self._private.elevation or 0
        local shadow_color = self._private.shadow_color or "#000"
        local opacity = elevation / 30 -- Adjust the opacity based on elevation, you can modify this formula

        cr:set_source_rgba(gears.color.parse_color(shadow_color))
        cr:paint_with_alpha(opacity)
        wibox.container.background.draw(self, context, cr, width, height)
    end,

    set_elevation = function(self, elevation)
        self._private.elevation = elevation
        self:emit_signal("widget::redraw_needed")
    end,

    set_shadow_color = function(self, color)
        self._private.shadow_color = color
        self:emit_signal("widget::redraw_needed")
    end,
}

ShadowContainer = class(wibox.container.background, ShadowContainer)

-- Updated hoverElevation function
function Animations:hoverElevation(widget, duration, elevation, callback)
    duration = duration or 0.3
    elevation = elevation or 5

    local original_elevation = widget._private.elevation or 0
    local target_elevation = original_elevation + elevation

    local timer = gears.timer {
        timeout = duration / 100,
        call_now = false,
        autostart = true,
        callback = function()
            local progress = (widget._private.elevation - original_elevation) / elevation
            widget:set_elevation(self.easing["outQuad"](progress, original_elevation, elevation, 1))

            if progress >= 1 then
                timer:stop()
                widget:set_elevation(target_elevation)

                if callback then
                    callback()
                end
            end
        end
    }
end


return Animations
