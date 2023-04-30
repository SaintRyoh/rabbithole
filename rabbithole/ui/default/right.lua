local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(rabbithole__components__wiboxes__bars__right)
        return function(s)
            rabbithole__components__wiboxes__bars__right(s):setup {
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                wibox.widget.textclock(),
            }
        end
    end
})