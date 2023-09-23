local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local beautiful = require("beautiful")
local darken = require("sub.nice.colors").darken

local MiniBar = {}

function MiniBar.new(options,
    settings
    )
    local minibar_size = dpi(34) or settings.minibar_size
    local colors = require("rabbithole.services.color") -- TODO: FOR SOME REASON DI DOESNT WOR0

    local minibar = awful.popup({
        screen = options.screen,
        widget = options.widget or wibox.container.background,
        ontop = false,
        visible = true,
        maximum_height = minibar_size,
        minimum_height = minibar_size,
        placement = function(c)
            options.placement(c, {
                margins = dpi(2)
            })
        end,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        border_width = dpi(0.5),
        border_color = darken(beautiful.base_color, 20),
    })
    minibar.bg = colors:smartGradient(beautiful.base_color, beautiful.secondary_color, minibar.height, minibar.width)
    minibar:struts{top = dpi(38)}

    return minibar
end

setmetatable(MiniBar, {
    __call = function(self, options)
        return self.new(options)
    end
})

return MiniBar
