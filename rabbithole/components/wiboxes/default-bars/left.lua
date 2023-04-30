local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__widgets__workspace___menu, 
        rabbithole__components__wiboxes__bars__left
    )
        return function(s)
            rabbithole__components__wiboxes__bars__left(s):setup {
                layout = wibox.layout.align.horizontal,
                rabbithole__components__widgets__workspace___menu
            }
        end
    end
})