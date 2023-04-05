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
        }


        config.bindings.types.workspaceMenu = "awesome-workspace-manager.widgets.workspace-menu"
        

        config.bindings.types.taglist = "taglist"
        config.providers.taglist = function()
            return RC.diModule.getInstance("awesome-workspace-manager.widgets.taglist")
        end

        config.bindings.types.layouts = "main.layouts_table"
        config.bindings.types.globalKeybindings = "binding.globalkeys"

    end),
    vars = require("main.user-variables"),
} 

RC.statusbar = RC.diModule.getInstance("deco.statusbar")

-- Standard awesome library
local awful = require("awful")
local menubar = require("menubar")

require("awful.hotkeys_popup.keys")
require("awful.autofocus")
require("main.error-handling")


modkey = RC.vars.modkey
editor_cmd = RC.vars.terminal .. " -e " .. RC.vars.editor



-- Custom Local Library
local main = {
    menu    = require("main.menu"),
    rules   = require("main.rules"),
}

-- Custom Local Library: Keys and Mouse Binding
local binding = {
    globalbuttons = require("binding.globalbuttons"),
    clientbuttons = require("binding.clientbuttons"),
    clientkeys    = require("binding.clientkeys")
}

-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys

-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher(
        {  menu = RC.mainmenu }
)

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = RC.vars.terminal

-- }}}

-- {{{ Mouse and Key bindings
-- RC.globalkeys = RC.diModule.getInstance("globalKeybindings")

-- Set root
root.buttons(binding.globalbuttons())
-- root.keys(RC.globalkeys)
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Statusbar: Wibar
-- require("deco.statusbar")
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = main.rules(
        binding.clientkeys(),
        binding.clientbuttons()
)
-- }}}

-- {{{ Signals
require("main.signals")
-- }}}

