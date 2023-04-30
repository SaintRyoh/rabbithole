return setmetatable({}, {
    __constructor = function (
        rabbithole__components__buttons__globalbuttons,
        rabbithole__components__keys__globalkeys
    )
        root.buttons(rabbithole__components__buttons__globalbuttons)
        root.keys(rabbithole__components__keys__globalkeys)
    end
})