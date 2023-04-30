-- This receives workspaceManagerService through dependency injection
-- returns a  function that will return a widget after receiving a screen
return setmetatable({}, {
    __constructor = function(
        workspaceManagerService, 
        theme,
        rabbithole__components__widgets__tasklist
    )
        return function (s)
            return require("rabbithole.components.widgets.taglist.controller")(workspaceManagerService, s, rabbithole__components__widgets__tasklist):get_view_widget()
        end
    end,
})