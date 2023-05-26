local wibox = require("wibox")
local systrayWidget= require("rabbithole.components.widgets.wonderlandSystray.systray")

return setmetatable({}, {
    __constructor = function(rabbithole__components__wiboxes__bars__right)
        return function(s)
            rabbithole__components__wiboxes__bars__right(s):setup {
                layout = wibox.layout.fixed.horizontal,
                systrayWidget,
                wibox.widget.textclock(),
            }
        end
    end
})