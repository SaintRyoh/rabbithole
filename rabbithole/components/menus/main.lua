local screen = require("awful.screen")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local freedesktop = require("sub.freedesktop")

return setmetatable({}, {
    __constructor = function (settings, rabbithole__services__modal)
        local M = {}  -- menu
        --local editor = settings.editor or "nano"
        local terminal = settings.terminal
        --local editor_cmd = settings.editor_cmd or terminal .. " -e " .. editor
        --local settings_manager = rabbithole__services__settingsManager.new()

        M.rabbithole = {
            { "Shortcuts...", function() hotkeys_popup.show_help(nil, screen.focused()) end },
            { "Launch term", terminal },
            { "Logout", awesome.quit },
            { "Restart WM", awesome.restart },
            -- launch insteace of settingsManager
            --{ "Settings Manager", function() settings_manager:show() end },
            { "Quit Rabbithole", function() awesome.quit() end },
            { "Reboot", "reboot" },
            { "Shutdown", "shutdown now" }
        }

        --M.favorite = {
        --    -- example of a favorite apps list
        --    -- usage: { "MenuText", "launch-command"}
--
        --    { "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" }
        --}

        M.network_main = {
            { "Bluetooth Devices", "blueman-manager" },
            { "WiFI Hotspot", "wihotspot-gui" }
        }

        -- Main Menu
        local menu_items = {
            { "Rabbithole", M.rabbithole, require("beautiful").rabbit_icon },
            { "Launch terminal", terminal },
            { "Wireless", M.network_main },
        }

        return freedesktop.menu.build({
            before = menu_items,
            sub_menu = 'Applications',
        })
    end
})