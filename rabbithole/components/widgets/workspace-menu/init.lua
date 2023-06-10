-- This receives workspaceManagerService through dependency injection
-- returns a widget
return setmetatable({}, {
    __constructor = function(workspaceManagerService, theme, rabbithole__services__modal, rabbithole__services__animation, rabbithole__services__color)
        local controller = require("rabbithole.components.widgets.workspace-menu.controller")
        return controller(workspaceManagerService, theme, rabbithole__services__modal, rabbithole__services__animation, rabbithole__services__color):get_view_widget()
    end,
})