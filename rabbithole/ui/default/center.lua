local wibox = require("wibox")
local layoutlist_widget = require("rabbithole.components.widgets.layout_list")

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__widgets__taglist, 
        rabbithole__components__wiboxes__bars__center,
        rabbithole__components__widgets__layout_list
    )
        return function(s)
            local custom_layoutlist = layoutlist_widget.new(s)

            rabbithole__components__wiboxes__bars__center(s):setup {
                layout = wibox.layout.align.horizontal,
                rabbithole__components__widgets__taglist(s),
                rabbithole__components__widgets__layout_list(s),
            }
        end
    end
})
