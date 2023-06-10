local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local beautiful = require("beautiful")
local colors = require("rabbithole.services.tesseractThemeEngine.colors")
local lighten = require("sub.nice.colors").lighten

local MiniBar = {}

function MiniBar.new(options)
    local minibar = awful.popup({
        screen = options.screen,
        widget = options.widget or wibox.container.background,
        ontop = false,
        visible = true,
        maximum_height = dpi(34),
        minimum_height = dpi(34),
        placement = function(c)
            options.placement(c, {
                margins = dpi(2)
            })
        end,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        border_width = dpi(0.5),
        border_color = lighten(beautiful.base_color, 15),
    })
    minibar:struts{top = dpi(34)}

    return minibar
end

setmetatable(MiniBar, {
    __call = function(self, options)
        return self.new(options)
    end
})

return MiniBar
