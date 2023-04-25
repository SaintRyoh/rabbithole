local wibox = require("wibox")
local gears = require("gears")

local Slider = {}


function Slider.new(args)
    local self = {}
    setmetatable(self, { __index = Slider })

    self.widget = self:createWidget(args)

    return self
end

function Slider:createWidget(args)
    local widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            id = "icon",
            widget = wibox.widget.imagebox,
            image = args.icon or nil,
            resize = true
        },
        {
            id = "slider",
            widget = wibox.widget.slider,
            value = args.value or 50,
            minimum = args.minimum or 0,
            maximum = args.maximum or 100,
            forced_width = args.forced_width or 200,
            forced_height = args.forced_height or 20,
            bar_shape = gears.shape.rounded_rect,
            handle_shape = gears.shape.circle,
            handle_color = args.handle_color or "#ffffff",
            bar_color = args.bar_color or "#000000",
            bar_active_color = args.bar_active_color or "#00ff00"
        }
    }

    widget.slider:connect_signal("button::press", function()
        widget.slider.is_dragging = true
    end)

    widget.slider:connect_signal("button::release", function()
        widget.slider.is_dragging = false
        args.animation_callback(widget.slider.value)
    end)

    return widget
end

return Slider
