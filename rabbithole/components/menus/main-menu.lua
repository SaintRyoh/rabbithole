-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Theme handling library
local beautiful = require("beautiful") -- for awesome.icon


-- reading
-- https://awesomewm.org/apidoc/popups%20and%20bars/awful.menu.html



return setmetatable({}, {
    __constructor = function (settings)
        local M = {}  -- menu
        local editor = settings.editor or "nano"
        local editor_cmd = settings.editor_cmd or terminal .. " -e " .. editor
        local terminal = settings.terminal or "xfce4-terminal"

        M.awesome = {
            { "hotkeys", function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end },
            { "manual", terminal .. " -e man awesome" },
            { "edit config", editor_cmd .. " " .. awesome.conffile },
            { "Terminal", terminal },
            { "Shutdown/Logout", "oblogout" },
            { "restart", awesome.restart },
            { "quit", function() awesome.quit() end }
        }

        M.favorite = {
            { "caja", "caja" },
            { "thunar", "thunar" },
            { "geany", "geany" },
            { "clementine", "clementine" },
            { "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" },
            { "chromium", "chromium" },
            { "&firefox", "firefox" },
            { "&thunderbird", "thunderbird" },
            { "libreoffice", "libreoffice" },
            { "transmission", "transmission-gtk" },
            { "gimp", "gimp" },
            { "inkscape", "inkscape" },
            { "screenshooter", "xfce4-screenshooter" }
        }

        M.network_main = {
            { "wicd-curses", "wicd-curses" },
            { "wicd-gtk", "wicd-gtk" }
        }
        -- Main Menu
        local menu_items = {
            { "awesome", M.awesome, beautiful.awesome_subicon },
            { "open terminal", terminal },
            { "network", M.network_main },
            { "favorite", M.favorite }
        }

        return awful.menu({ items = menu_items })
    end
})