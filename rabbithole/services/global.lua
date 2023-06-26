local awful = require("awful")
local gears = require("gears")
--local autorandr = require("scripts.autorandr-dbus") -- listens for udev changes in the display and runs autorandr -c

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__buttons__global,
        rabbithole__components__keys__global,
        rabbithole__components__layouts__default,
        rabbithole__components__rules__client___default,
        rabbithole__services__rabid___daemons
    )
        -- Set what happens when you click on the desktop
        root.buttons(rabbithole__components__buttons__global)

        -- Set global keybindings
        root.keys(rabbithole__components__keys__global)

        -- Set default layout list
        awful.layout.layouts = rabbithole__components__layouts__default
        -- Set default client rules
        awful.rules.rules = gears.table.join(
            awful.rules.rules,
            rabbithole__components__rules__client___default
        )
        -- Run daemons and applications last, set a timer for 3 seconds
        gears.timer {
            timeout = 3,
            autostart = true,
            callback = rabbithole__services__rabid___daemons:run()
        }
    end
})
