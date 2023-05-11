-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Theme handling library
local beautiful = require("beautiful") -- for awesome.icon
local freedesktop = require("sub.freedesktop")


return setmetatable({}, {
    __constructor = function (settings)
        local M = {}  -- menu
        local editor = settings.editor or "nano"
        local terminal = settings.terminal or "xfce4-terminal"
        local editor_cmd = settings.editor_cmd or terminal .. " -e " .. editor

        M.rabbithole = {
            { "Shortcuts cheatsheet", function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end },
            --{ "AWM Manual", terminal .. " -e man awesome" },
            { "Launch terminal", terminal },
            { "Logout", "oblogout" },
            { "Restart", awesome.restart },
            { "Quit Rabbithole", function() awesome.quit() end }
        }

        M.favorite = {
            -- example of a favorite apps list
            -- usage: { "MenuText", "launch-command"}

            { "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" }
        }

        M.network_main = {
            { "Wireless Hotspot", "wicd-curses" }
        }
        M.applications = freedesktop.menu.build()
        -- Main Menu
        local menu_items = {
            { "Rabbithole", M.rabbithole, beautiful.awesome_subicon },
            { "Launch terminal", terminal },
            { "WiFi", M.network_main },
            { "Applications", M.applications }
            --{ "favorite", M.favorite }
        }

        return awful.menu({ items = menu_items })
    end
})