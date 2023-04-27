local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(awesome___workspace___manager__wibox__bars__right)
        return function(s)
            awesome___workspace___manager__wibox__bars__right(s):setup {
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                wibox.widget.textclock(),
            }
        end
    end
})