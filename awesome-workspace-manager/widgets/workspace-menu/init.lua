-- This receives workspaceManagerService through dependency injection
-- returns a widget
return setmetatable({}, {
    __constructor = function(workspaceManagerService)
        -- RC.diModule.getInstance("debugger").dbg()
        local controller = require("awesome-workspace-manager/widgets/workspace-menu/controller")
        return controller(workspaceManagerService):get_view_widget()
    end,
})