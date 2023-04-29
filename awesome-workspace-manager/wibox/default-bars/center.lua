local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local layoutlist_widget = require("awesome-workspace-manager.widgets.layout_list")

return setmetatable({}, {
    __constructor = function(taglist, awesome___workspace___manager__wibox__bars__center)
        return function(s)
            local custom_layoutlist = layoutlist_widget.new(s)

            awesome___workspace___manager__wibox__bars__center(s):setup {
                layout = wibox.layout.align.horizontal,
                taglist(s),
                custom_layoutlist,
            }
        end
    end
})
