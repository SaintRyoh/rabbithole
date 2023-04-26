local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local TestWidget = {}

-- Define the target background color and animation duration
local hover_bg_color = beautiful.bg_focus
local hover_anim_duration = 0.2 -- seconds

-- Animate the background color of the widget on mouse enter and leave
local function add_hover_animation(widget)
    widget:connect_signal("mouse::enter", function()
        -- Animate the background color to the hover color using Material Design 3 easing
        gears.timer.start_new(hover_anim_duration, function(t)
            local progress = t / hover_anim_duration
            local eased_progress = 1 - math.pow(1 - progress, 2.5) -- Material Design 3 easing
            widget.bg = gears.color.interpolate_color(beautiful.bg_normal, hover_bg_color, eased_progress)
            return progress < 1
        end)
    end)

    widget:connect_signal("mouse::leave", function()
        -- Animate the background color back to the default color using Material Design 3 easing
        gears.timer.start_new(hover_anim_duration, function(t)
            local progress = t / hover_anim_duration
            local eased_progress = 1 - math.pow(1 - progress, 2.5) -- Material Design 3 easing
            widget.bg = gears.color.interpolate_color(hover_bg_color, beautiful.bg_normal, eased_progress)
            return progress < 1
        end)
    end)
end

-- Create a test widget with hover animation applied
function TestWidget.create()
    local widget = wibox.widget {
        text = "Hover over me!",
        widget = wibox.widget.textbox,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        shape = gears.shape.rounded_rect,
        shape_border_width = 2,
        shape_border_color = beautiful.border_color,
    }

    add_hover_animation(widget)

    return widget
end

return TestWidget