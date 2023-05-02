-- This receives workspaceManagerService through dependency injection
-- returns a  function that will return a widget after receiving a screen
return setmetatable({}, {
    __constructor = function(
        workspaceManagerService, 
        theme,
        rabbithole__components__widgets__tasklist,
        rabbithole__services__tag___preview
    )
        return function (s)
            return require("rabbithole.components.widgets.taglist.controller")(
                workspaceManagerService, 
                s, 
                rabbithole__components__widgets__tasklist,
                rabbithole__services__tag___preview
            ):get_view_widget()
        end
    end,
})