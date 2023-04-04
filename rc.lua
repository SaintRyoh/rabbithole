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
        config.singletons.theme = true
        config.providers.theme = function()
            return RC.diModule.getInstance("awesome-workspace-manager.theme")
        end

        config.bindings.values.settings = {
            theme_dir = "themes/rabbithole/theme.lua",
        }

        config.bindings.types.workspaceMenu = "awesome-workspace-manager.widgets.workspace-menu"

    end),
    vars = require("main.user-variables"),
} 

RC.workspaceManagerService = RC.diModule.getInstance("workspaceManagerService")
RC.theme = RC.diModule.getInstance( "theme")
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
    layouts = require("main.layouts"),
    menu    = require("main.menu"),
    rules   = require("main.rules"),
}

-- Custom Local Library: Keys and Mouse Binding
local binding = {
    globalbuttons = require("binding.globalbuttons"),
    clientbuttons = require("binding.clientbuttons"),
    globalkeys    = require("binding.globalkeys"),
    clientkeys    = require("binding.clientkeys")
}



-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
-- a variable needed in main.tags, and statusbar
-- awful.layout.layouts = { ... }
RC.layouts = main.layouts()
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys



-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys

-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher(
        { image = RC.theme.awesome_icon, menu = RC.mainmenu }
)

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = RC.vars.terminal

-- }}}

-- {{{ Mouse and Key bindings
RC.globalkeys = binding.globalkeys(RC.workspaceManagerService)

-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)
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

