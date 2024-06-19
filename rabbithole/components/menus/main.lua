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
            { "Logout", awesome.quit },
            { "Restart WM", awesome.restart },
            -- launch insteace of settingsManager
            --{ "Settings Manager", function() settings_manager:show() end },
            { "Quit Rabbithole", awesome.quit },
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
        
        -- Add the custom menu only if it's not nil
        if settings.custom_menu ~= nil then
            table.insert(menu_items, { "Custom", MainMenu.custom })
        end
        
        return freedesktop.menu.build({
            before = menu_items,
            sub_menu = 'Applications',
        })
    end
})