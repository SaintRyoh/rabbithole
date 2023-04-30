-- setup paths, includes things like lua_modules
require("paths")
require("main.error-handling")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- if AWM_DEBUG set in environment then require debug
if os.getenv("AWM_DEBUG") then
    Debugger = require("debug")
end


-- global namespace, on top before require any modules
RC = {
    diModule = require("sub.lua-di.lua-di.DependencyInjectionModule")(function (config) 
        -- Make workspaceManagerService a singleton
        config.bindings.types.workspaceManagerService = "workspaceManagerService"
        config.singletons.workspaceManagerService = true
        config.providers.workspaceManagerService = function()
            return RC.diModule.getInstance("rabbithole.services.workspaceManagerService") 
        end


        -- Make theme a singleton (so we only call beautiful.init once)
        config.bindings.types.theme = "rabbithole.systems.theme-loader"
        config.singletons.theme = true


        config.bindings.values.settings = {
            theme_dir = "themes/rabbithole/theme.lua",
            modkey = "Mod4",
            terminal = "qterminal",
            editor = os.getenv("EDITOR") or "nvim",
            editor_cmd = "qterminal -e nvim",
        }

        -- this is just a taglist function that returns a widget if you give it a screen
        config.bindings.types.taglist = "taglist"
        config.providers.taglist = function()
            return RC.diModule.getInstance("rabbithole.components.widgets.taglist")
        end

        config.bindings.types.titlebar = "rabbithole.components.wiboxes.titlebar"

        config.enableAutoConfiguration()

    end),
} 

RC.environment = RC.diModule.getInstance("rabbithole.environment")
