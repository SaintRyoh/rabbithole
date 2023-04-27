local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(taglist, awesome___workspace___manager__wibox__bars__center)
        return function(s)
            awesome___workspace___manager__wibox__bars__center(s):setup {
                layout = wibox.layout.align.horizontal,
                taglist(s)
            }
        end
    end
})