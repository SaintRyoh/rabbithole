-- setup paths, includes things like lua_modules
require("paths")
require("main.error-handling")

Debugger = require("rabbithole.services.debug.init")

-- global namespace, on top before require any modules
RC = {
    diModule = require("lua-di.lua-di.DependencyInjectionModule")(function (config) 
        -- Make workspaceManagerService a singleton
        config.bindings.types.workspaceManagerService = "workspaceManagerService"
        config.singletons.workspaceManagerService = true
        config.providers.workspaceManagerService = function()
            return RC.diModule.getInstance("rabbithole.workspaceManagerService") 
        end

        -- config.singletons.debug = true
        -- config.providers.debugger = require("rabbithole.debug")


        -- Make theme a singleton (so we only call beautiful.init once)
        config.bindings.types.theme = "rabbithole.services.theme-loader"
        config.singletons.theme = true


        config.bindings.values.settings = {
            theme_dir = "themes/rabbithole/theme.lua",
            modkey = "Mod4",
            terminal = "qterminal",
            editor = os.getenv("EDITOR") or "nvim",
            editor_cmd = "qterminal -e nvim",
        }


        config.bindings.types.workspaceMenu = "rabbithole.components.widgets.workspace-menu"
        

        -- this is just a taglist function that returns a widget if you give it a screen
        config.bindings.types.taglist = "taglist"
        config.providers.taglist = function()
            return RC.diModule.getInstance("rabbithole.components.widgets.taglist")
        end

        config.bindings.types.layouts = "main.layouts_table"
        config.bindings.types.globalKeybindings = "binding.globalkeys"
        config.bindings.types.clientKeybindings = "binding.clientkeys"
        config.bindings.types.clientButtons = "binding.clientbuttons"
        config.bindings.types.mainmenu = "main.menu"
        config.bindings.types.globalMouseButtons = "binding.globalbuttons"
        config.bindings.types.rules = "main.rules"
        config.bindings.types.statusbar = "deco.statusbar"
        config.bindings.types.titlebar = "deco.titlebar"

        config.singletons.enableAutoFocus = true
        config.providers.enableAutoFocus = require("awful.autofocus")

        config.singletons.hotKeyKeys = true
        config.providers.hotKeyKeys = require("awful.hotkeys_popup.keys")

        config.enableAutoConfiguration()

    end),
} 

RC.environment = RC.diModule.getInstance("rabbithole.environment")
