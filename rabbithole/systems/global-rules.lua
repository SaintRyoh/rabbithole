local awful = require("awful")

return setmetatable({}, {
    __constructor = function (
        rabbithole__components__buttons__globalbuttons,
        rabbithole__components__keys__globalkeys,
        rabbithole__components__layouts__default___layouts
    )
        root.buttons(rabbithole__components__buttons__globalbuttons)
        root.keys(rabbithole__components__keys__globalkeys)
        awful.layout.layouts = rabbithole__components__layouts__default___layouts
    end
})