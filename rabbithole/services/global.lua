local awful = require("awful")
local gears = require("gears")

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
        -- awful.rules.rules = rabbithole__components__rules__client___default
        awful.rules.rules = gears.table.join(
            awful.rules.rules,
            rabbithole__components__rules__client___default
        )

        -- Spawn clients in the autostart settings
        for _, app in ipairs(settings.autostart_apps) do
            awful.spawn.with_shell(app)
        end
    end
})
