-- setup paths, includes things like lua_modules
require("paths")
require("error-handling")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
local gears = require("gears.filesystem")

-- if AWM_DEBUG set in environment then require debug
-- Debugger = nil
-- if os.getenv("AWM_DEBUG") == '1' then
    Debugger = require("awm-debug")
-- end

-- global namespace, on top before require any modules
RC = {
    diModule = require("sub.lua-di.lua-di.DependencyInjectionModule")(function (config) 

        -- eventually only Services and Settings should be

        -- Make workspaceManagerService a singleton
        config.bindings.types.workspaceManagerService = "workspaceManagerService"
        config.singletons.workspaceManagerService = true
        config.providers.workspaceManagerService = function()
            return RC.diModule.getInstance("rabbithole.services.workspaceManagerService") 
        end


        -- Make theme a singleton (so we only call beautiful.init once) (this will need to be changed when we add theme switching)
        config.bindings.types.theme = "rabbithole.services.theme-loader"
        config.singletons.theme = true


        config.bindings.values.settings = {
            theme_dir = "themes/rabbithole/theme.lua",
            modkey = "Mod4",
            terminal = "qterminal",
            editor = os.getenv("EDITOR") or "nvim",
            editor_cmd = "qterminal -e nvim",
            wallpaper = { }
        }

        config.enableAutoConfiguration()

    end),
} 

RC.environment = RC.diModule.getInstance("rabbithole.environment")
