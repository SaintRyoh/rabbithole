local awful = require("awful")
local gears = require("gears")
local __ = require("lodash")
--local autorandr = require("scripts.autorandr-dbus") -- listens for udev changes in the display and runs autorandr -c

return setmetatable({}, {
    __constructor = function (
        settings,
        rabbithole__components__buttons__global,
        rabbithole__components__keys__global,
        rabbithole__components__layouts__default,
        rabbithole__components__rules__client___default
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

        -- Spawn clients in the daemons settings
        if settings.daemons then
            __.forEach(settings.daemons, function(daemon)
                awful.spawn.with_shell(daemon)
            end)
        end
        -- Autostart applications
        if settings.autostart_apps then
            __.forEach(settings.autostart_apps, function(app)
                awful.spawn.with_shell(app)
            end)
        end
    end
})
