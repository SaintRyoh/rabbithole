local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(workspaceMenu, awesome___workspace___manager__wibox__bars__left)
        return function(s)
            awesome___workspace___manager__wibox__bars__left(s):setup {
                layout = wibox.layout.align.horizontal,
                workspaceMenu
            }
        end
    end
})