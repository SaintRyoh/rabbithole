-- This receives workspaceManagerService through dependency injection
-- returns a widget
return setmetatable({}, {
    __constructor = function(workspaceManagerService)
        return function (s)
            return require("awesome-workspace-manager/widgets/taglist/controller")(workspaceManagerService, s):get_view_widget()
        end
    end,
})