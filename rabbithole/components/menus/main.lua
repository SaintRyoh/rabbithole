-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Theme handling library
local beautiful = require("beautiful") -- for rabbithole icon
local freedesktop = require("sub.freedesktop")
local apps = require("rabbithole.services.appService")


return setmetatable({}, {
    __constructor = function (settings)
        local M = {}  -- menu
        local editor = settings.editor or "nano"
        local terminal = settings.terminal or "xfce4-terminal"
        local editor_cmd = settings.editor_cmd or terminal .. " -e " .. editor

        M.rabbithole = {
            { "Shortcuts...", function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end },
            --{ "AWM Manual", terminal .. " -e man awesome" },
            { "Launch terminal", terminal },
            { "Logout", function() awesome.quit() end },
            { "Restart WM", awesome.restart },
            { "Quit Rabbithole", function() awesome.quit() end },
            { "Reboot", "reboot" },
            { "Shutdown", "shutdown now" }

        }

        M.favorite = {
            -- example of a favorite apps list
            -- usage: { "MenuText", "launch-command"}

            { "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" }
        }

        M.network_main = {
            { "Hotspot", "wihotspot-gui" }
        }
        -- Create an applications submenu from freedesktop
        M.applications = apps.get_apps()
        -- Main Menu
        local menu_items = {
            { "Rabbithole", M.rabbithole, beautiful.rabbit_menu},
            { "Terminal", terminal },
            --{ "WiFi", M.network_main },
            { "Applications", M.applications }
            --{ "favorite", M.favorite }
        }

        return awful.menu({ items = menu_items })
    end
})