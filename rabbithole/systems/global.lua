local awful = require("awful")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__buttons__global,
        rabbithole__components__keys__globalkeys,
        rabbithole__components__layouts__default___layouts,
        rabbithole__components__rules__client___default
    )
        -- Set what happens when you click on the desktop
        root.buttons(rabbithole__components__buttons__global)

        -- Set global keybindings
        root.keys(rabbithole__components__keys__globalkeys)

        -- Set default layout list
        awful.layout.layouts = rabbithole__components__layouts__default___layouts

        -- Set default client rules
        awful.rules.rules = rabbithole__components__rules__client___default
    end
})