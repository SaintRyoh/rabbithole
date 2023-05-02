local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local layoutlist_widget = require("rabbithole.components.widgets.layout_list")

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__widgets__taglist, 
        rabbithole__components__wiboxes__bars__center
    )
        return function(s)
            local custom_layoutlist = layoutlist_widget.new(s)

            rabbithole__components__wiboxes__bars__center(s):setup {
                layout = wibox.layout.align.horizontal,
                rabbithole__components__widgets__taglist(s),
                custom_layoutlist,
            }
        end
    end
})
