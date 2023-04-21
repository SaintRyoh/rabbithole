local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

MiniBar = {}
MiniBar.__index = MiniBar

function MiniBar.new(options)
    local rabid_bar = awful.popup({
        screen = options.screen,
        widget = options.widget or wibox.container.background,
        ontop = true,
        visible = true,
        maximum_width = dpi(600),
        placement = options.placement,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 5)
        end
    })

    rabid_bar:struts{top = dpi(34)}
    return rabid_bar
end

return setmetatable(MiniBar, {
    __call = function(self, options)
        return self.new(options)
    end
})