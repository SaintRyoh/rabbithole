local awful = require("awful")
local beautiful = require("beautiful")
local bling = require("sub.bling")
local dropdown = require("rabbithole.services.dropdown")

local UserInterface = {}
UserInterface.__index = UserInterface

function UserInterface.new(
    workspaceManagerService,
    rabbithole__ui__default__left,
    rabbithole__ui__default__center,
    rabbithole__ui__default__right,
    settings,
    rabbithole__services__screen___dpi
    --rabbithole__ui__default__titlebar  -- Using nice as titlebars for now, but standard titlebars are still available if desired
)
    local dpi = rabbithole__services__screen___dpi:get_screen_dpi()
    awful.screen.connect_for_each_screen(function(s)
        -- set auto dpi detection for each screen for consistent UserInterface
        --s:set_auto_dpi_enabled(true)
        
        workspaceManagerService:assignWorkspaceTagsToScreens()

        -- initialize left and right bars for first screen only, and taglist widget for all screens
        if s.index == 1 then
            rabbithole__ui__default__left(s)
            rabbithole__ui__default__right(s)
        end
        rabbithole__ui__default__center(s)

        -- create dropdown terminal box for each screen
        s.dropdown = dropdown({app=settings.drivers.terminal, argname="--title %s", extra="--class Dropdown -e tmux", visible=true, height=0.9, screen = s })
        
        -- set scrreen dpi
        beautiful.xresources.set_dpi(dpi, s)

        bling.module.wallpaper.setup {
            screen = s,
            set_function = bling.module.wallpaper.setters.simple,
            wallpaper = beautiful.wallpaper,
            position = "maximized",
            ignore_aspect = true,
        }
    end)
end

return UserInterface
