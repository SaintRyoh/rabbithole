-- This receives workspaceManagerService through dependency injection
-- returns a widget
return setmetatable({}, {
    __constructor = function(workspaceManagerService)
        local controller = require("awesome-workspace-manager/widgets/taglist/controller")
        return function (s)
            return controller(workspaceManagerService, s):get_view_widget()
        end
    end,
})