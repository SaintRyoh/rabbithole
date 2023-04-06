return setmetatable({}, {
    __constructor = function(statusbar, layouts, globalKeybindings, clientKeybindings, mainmenu, globalMouseButtons, rules)
        local self = {
            statusbar = statusbar,
            layouts = layouts,
            globalKeybindings = globalKeybindings,
            clientKeybindings = clientKeybindings,
            mainmenu = mainmenu,
            globalMouseButtons = globalMouseButtons,
            rules = rules,
        }
        return self
    end,
})