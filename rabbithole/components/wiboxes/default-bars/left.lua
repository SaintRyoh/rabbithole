local wibox = require("wibox")

return setmetatable({}, {
    __constructor = function(workspaceMenu, rabbithole__components__wiboxes__bars__left)
        return function(s)
            rabbithole__components__wiboxes__bars__left(s):setup {
                layout = wibox.layout.align.horizontal,
                workspaceMenu
            }
        end
    end
})