require("paths")
require("error-handling")
require("awful.hotkeys_popup.keys")

-- if AWM_DEBUG set in environment then require debug
-- Debugger = nil
-- if os.getenv("AWM_DEBUG") == '1' then
    Debugger = require("awm-debug")
-- end

-- global namespace, on top before require any modules
RC = {
    diModule = require("sub.lua-di.lua-di.DependencyInjectionModule")(function(config)

        -- Make workspaceManagerService a singleton
        config.bindings.types.workspaceManagerService = "workspaceManagerService"
        config.singletons.workspaceManagerService = true
        config.providers.workspaceManagerService = function()
            return RC.diModule.getInstance("rabbithole.services.workspaceManagerService")
        end

        config.bindings.values.settings = require("settings")
        config.bindings.types.theme = "rabbithole.services.theme-loader"
        config.singletons.theme = true -- change theme from a singleton when we implement a live theme-switcher

        config.enableAutoConfiguration()

    end)
}

RC.environment = RC.diModule.getInstance("rabbithole.environment")
