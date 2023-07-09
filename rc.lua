require("paths")
require("error-handling")

-- if AWM_DEBUG set in environment then require debug
Debugger = nil
if os.getenv("AWM_DEBUG") == '1' or true then
    Debugger = require("awm-debug")
end

-- global namespace, on top before require any modules
RC = {

    -- Reading:
    -- https://github.com/djfdyuruiry/lua-di
    diModule = require("sub.lua-di.lua-di.DependencyInjectionModule")
    (function(config)

        -- Only Register:
        --   Singletons (i.e. types that need to be instantiated only once)
        --   Values
        --   Providers

        -- Otherwise you should be using the auto configuration
        config.enableAutoConfiguration()


        --
        -- Singletons
        -- Note: Singletons must be instantiated by a provider

        config.bindings.types.workspaceManagerService = "workspaceManagerService"
        config.singletons.workspaceManagerService = true
        config.providers.workspaceManagerService = function()
            return RC.diModule.getInstance("rabbithole.services.workspaceManagerService")
        end


        config.bindings.types.theme = "rabbithole.services.theme-loader"
        config.singletons.theme = true -- change theme from a singleton when we implement a live theme-switcher

        config.bindings.types.dragondrop = "dragondrop"
        config.singletons.dragondrop = true
        config.providers.dragondrop = function()
            return RC.diModule.getInstance("rabbithole.services.dragondrop")
        end
        --
        -- Values
        config.bindings.values.settings = require("settings")



    end)
}

RC.environment = RC.diModule.getInstance("rabbithole.environment")
