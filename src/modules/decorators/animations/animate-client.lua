local awful = require("awful")
local gears = require("gears")
local client = require("awful.client")

-- Easing functions
local function linear(t)
    return t
end

local function ease_in_quad(t)
    return t * t
end

local function ease_out_quad(t)
    return t * (2 - t)
end

local function animate_client(c, duration, easing, callback)
    local start_time = gears.timer.seconds()
    local initial_x = c.x
    local initial_y = c.y
    local target_x = 100  -- Desired target X position
    local target_y = 100  -- Desired target Y position

    local function ease_position()
        local elapsed = gears.timer.seconds() - start_time
        local progress = math.min(elapsed / duration, 1)
        local eased_progress = easing(progress)

        c.x = initial_x + (target_x - initial_x) * eased_progress
        c.y = initial_y + (target_y - initial_y) * eased_progress

        if progress == 1 then
            gears.timer.stop_new(ease_position)
            if callback then callback() end
        end
    end

    gears.timer.start_new(0.01, ease_position)
end

-- Example usage: move the focused client to (100, 100) with acceleration
--if client.focus then
--    animate_client(client.focus, 0.5, ease_in_quad)
--end
