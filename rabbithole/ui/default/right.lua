local wibox = require("wibox")
local systrayWidget = require("rabbithole.components.widgets.wonderlandSystray.systray")
local clock = require("rabbithole.components.widgets.clock")
local date_cal = require("rabbithole.components.widgets.date_cal")

return setmetatable({}, {
    __constructor = function(rabbithole__components__wiboxes__bars__right)
        return function(s)
            rabbithole__components__wiboxes__bars__right(s):setup {
                layout = wibox.layout.fixed.horizontal,
                systrayWidget,
                date_cal.widget,
                clock.widget,
            }
        end
    end
})