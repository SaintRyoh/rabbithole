local screen = require("awful.screen")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local freedesktop = require("sub.freedesktop")

return setmetatable({}, {
    __constructor = function (settings, rabbithole__services__modal)
        local MainMenu = { }
        local terminal = settings.drivers.terminal

        MainMenu.rabbithole = {
            { "Shortcuts...", function() hotkeys_popup.show_help(nil, screen.focused()) end },
            { "Launch term", terminal },
            { "Logout", function() awesome.quit() end },
            { "Restart WM", awesome.restart },
            -- launch insteace of settingsManager
            --{ "Settings Manager", function() settings_manager:show() end },
            { "Quit Rabbithole", function() awesome.quit() end },
            { "Reboot", "reboot" },
            { "Shutdown", "shutdown now" }
        }
        
        --M.Favorites = {
            -- example of a favorite apps list
            -- usage: { "MenuText", "launch-command"}

            --{ "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" }

        --}

        MainMenu.network_main = {
            { "Bluetooth Devices", "blueman-manager" },
            { "WiFI Hotspot", "wihotspot-gui" }
        }

        local menu_items = {
            { "Rabbithole", MainMenu.rabbithole, require("beautiful").rabbit_icon },
            { "Launch terminal", terminal },
            { "Wireless", MainMenu.network_main },
        }
        
        local custom_menu = settings.custom_menu
        if custom_menu then
            table.insert(menu_items, { "Custom", settings.custom_menu })
        end
        
        return freedesktop.menu.build({
            before = menu_items,
            sub_menu = 'Applications',
        })
    end
})