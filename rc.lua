-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")


-- https://leafo.net/guides/customizing-the-luarocks-tree.html
local version = _VERSION:match("%d+%.%d+")
package.path = './?.lua;./?/init.lua;lua_modules/share/lua/' .. version .. '/?.lua;lua_modules/share/lua/' .. version .. '/?/init.lua;' .. package.path
package.cpath = 'lua_modules/lib/lua/' .. version .. '/?.so;' .. package.cpath

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library

-- Theme handling library
local beautiful = require("beautiful")
local menubar = require("menubar")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Local extensions
__ = require("lodash")
-- }}}

RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")


-- {{{ Error handling
require("main.error-handling")
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("themes/zenburn/theme.lua")
--beautiful.wallpaper = RC.vars.wallpaper
-- }}}

modkey = RC.vars.modkey
editor_cmd = RC.vars.terminal .. " -e " .. RC.vars.editor

-- Custom Local Library
local main = {
    layouts = require("main.layouts"),
    tags    = require("main.tags"),
    menu    = require("main.menu"),
    rules   = require("main.rules"),
}

-- Custom Local Library: Keys and Mouse Binding
local binding = {
    globalbuttons = require("binding.globalbuttons"),
    clientbuttons = require("binding.clientbuttons"),
    globalkeys    = require("binding.globalkeys"),
    bindtotags    = require("binding.bindtotags"),
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
RC.tags = main.tags()
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
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)

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

