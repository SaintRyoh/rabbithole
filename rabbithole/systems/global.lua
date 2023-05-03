local awful = require("awful")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__buttons__globalbuttons,
        rabbithole__components__keys__globalkeys,
        rabbithole__components__layouts__default___layouts,
        rabbithole__components__rules__client___default
    )
        root.buttons(rabbithole__components__buttons__globalbuttons)
        root.keys(rabbithole__components__keys__globalkeys)
        awful.layout.layouts = rabbithole__components__layouts__default___layouts
        awful.rules.rules = rabbithole__components__rules__client___default
    end
})