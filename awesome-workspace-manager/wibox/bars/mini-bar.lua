local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

MiniBar = {}
MiniBar.__index = MiniBar

function MiniBar.new(options)
    local minibar = awful.popup({
        screen = options.screen,
        widget = options.widget or wibox.container.background,
        ontop = true,
        visible = true,
        maximum_height = dpi(30),
        placement = options.placement,
    })
    minibar:struts{top = dpi(30)}

    return minibar
end

return setmetatable(MiniBar, {
    __call = function(self, options)
        return self.new(options)
    end
})