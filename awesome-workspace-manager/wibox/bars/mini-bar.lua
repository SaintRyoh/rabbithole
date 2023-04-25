local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")

MiniBar = {}
MiniBar.__index = MiniBar

function MiniBar.new(options)
    local minibar = awful.popup({
        screen = options.screen,
        widget = options.widget or wibox.container.background,
        ontop = false,
        visible = true,
        maximum_height = dpi(30),
        placement = options.placement,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
    })
    minibar:struts{top = dpi(30)}

    return minibar
end

return setmetatable(MiniBar, {
    __call = function(self, options)
        return self.new(options)
    end
})