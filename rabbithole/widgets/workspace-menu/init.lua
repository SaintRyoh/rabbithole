-- This receives workspaceManagerService through dependency injection
-- returns a widget
return setmetatable({}, {
    __constructor = function(workspaceManagerService, theme)
        local controller = require("rabbithole/widgets/workspace-menu/controller")
        return controller(workspaceManagerService, theme):get_view_widget()
    end,
})