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

    end),
} 

RC.statusbar = RC.diModule.getInstance("deco.statusbar")

require("awful.hotkeys_popup.keys")
require("awful.autofocus")


local awful = require("awful")
-- Custom Local Library
local main = {
    rules   = require("main.rules"),
}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- awful.rules.rules = main.rules(
--         RC.diModule.getInstance("binding.clientkeys"),
--         RC.diModule.getInstance("binding.clientbuttons")
-- )
-- }}}

require("main.signals")
require("main.error-handling")

