-- setup paths, includes things like lua_modules
require("paths")

-- global namespace, on top before require any modules
RC = {
    diModule = require("lua-di.lua-di.DependencyInjectionModule")(function (config) 
        -- Make workspaceManagerService a singleton
        config.bindings.types.workspaceManagerService = "workspaceManagerService"
        config.singletons.workspaceManagerService = true
        config.providers.workspaceManagerService = function()
            return RC.diModule.getInstance("awesome-workspace-manager.workspaceManagerService") 
        end


        -- Make debugger a singleton
        config.singletons.debugger = true
        config.providers.debugger = require("awesome-workspace-manager.debug")


        -- Make theme a singleton (so we only call beautiful.init once)
        config.bindings.types.theme = "awesome-workspace-manager.theme"
        config.singletons.theme = true


        config.bindings.values.settings = {
            theme_dir = "themes/rabbithole/theme.lua",
            modkey = "Mod4",
            terminal = "qterminal",
            editor = os.getenv("EDITOR") or "nvim",
            editor_cmd = "qterminal -e nvim",
        }


        config.bindings.types.workspaceMenu = "awesome-workspace-manager.widgets.workspace-menu"
        

        -- this is just a taglist function that returns a widget if you give it a screen
        config.bindings.types.taglist = "taglist"
        config.providers.taglist = function()
            return RC.diModule.getInstance("awesome-workspace-manager.widgets.taglist")
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

    end),
} 

RC.environment = RC.diModule.getInstance("awesome-workspace-manager.environment")


-- require("deco.titlebar")
require("main.signals")
require("main.error-handling")

