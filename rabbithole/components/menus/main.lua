-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Theme handling library
local rabbit_icon = require("beautiful").rabbit_icon
local freedesktop = require("sub.freedesktop")
local naughty = require("naughty")


return setmetatable({}, {
    __constructor = function (settings, rabbithole__services__modal)
        local M = {}  -- menu
        --local editor = settings.editor or "nano"
        local terminal = settings.terminal or "xfce4-terminal"
        --local editor_cmd = settings.editor_cmd or terminal .. " -e " .. editor
        --local settings_manager = rabbithole__services__settingsManager.new()

        M.rabbithole = {
            { "Shortcuts...", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
            { "Launch term", terminal },
            { "Logout", function() awesome.quit() end },
            { "Restart WM", awesome.restart },
            -- launch insteace of settingsManager
            --{ "Settings Manager", function() settings_manager:show() end },
            { "Quit Rabbithole", function() awesome.quit() end },
            { "Reboot", "reboot" },
            { "Shutdown", "shutdown now" },
            { "Test confirm modal", function ()
                rabbithole__services__modal:confirm()
            end}

        }

        --M.favorite = {
        --    -- example of a favorite apps list
        --    -- usage: { "MenuText", "launch-command"}
--
        --    { "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" }
        --}

        M.network_main = {
            { "WiFI Hotspot", "wihotspot-gui" }
        }

        -- Main Menu
        local menu_items = {
            { "Rabbithole", M.rabbithole, rabbit_icon},
            { "Launch terminal", terminal },
            { "WiFi", M.network_main },
        }

        return freedesktop.menu.build({
            before = menu_items,
            sub_menu = 'Applications',
        })
    end
})