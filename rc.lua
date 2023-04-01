RC = {} -- global namespace, on top before require any modules

-- setup paths, includes things like lua_modules
require("paths")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")

RC.vars = require("main.user-variables")
require("awful.hotkeys_popup.keys")
require("awful.autofocus")
require("main.error-handling")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_dir = "themes/rabbithole/theme.lua"
if gears.filesystem.file_readable(gears.filesystem.get_configuration_dir() .. theme_dir) then
    beautiful.init(gears.filesystem.get_configuration_dir() .. theme_dir)
else
    beautiful.init("themes/zenburn/theme.lua")
end
--beautiful.wallpaper = RC.vars.wallpaper
-- }}}

modkey = RC.vars.modkey
editor_cmd = RC.vars.terminal .. " -e " .. RC.vars.editor

RC.workspaceManagerService = require("awesome-workspace-manager")()

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


-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- a variable needed in rules, tasklist, and globalkeys
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys



-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys

-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher(
        { image = beautiful.awesome_icon, menu = RC.mainmenu }
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
require("deco.statusbar")
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

