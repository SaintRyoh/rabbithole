local awful = require("awful")
local beautiful = require("beautiful")
local bling = require("sub.bling")

local UserInterface = {}
UserInterface.__index = UserInterface

function UserInterface.new(
    workspaceManagerService,
    rabbithole__ui__default__left,
    rabbithole__ui__default__center,
    rabbithole__ui__default__right
    --rabbithole__ui__default__titlebar  -- Using nice as titlebars for now, but standard titlebars are still available if desired
)
    awful.screen.connect_for_each_screen(function(s)

        workspaceManagerService:assignWorkspaceTagsToScreens()

        -- initialize left and right bars for first screen only, and taglist widget for all screens
        if s.index == 1 then
            rabbithole__ui__default__left(s)
            rabbithole__ui__default__right(s)
        end
        rabbithole__ui__default__center(s)

        -- set dpi of screens
        local resolution = s.geometry.width * s.geometry.height
        local dpi

        if resolution > 1920 * 1080 then
            dpi = 144 -- or whatever value you want for high DPI screens
        elseif resolution > 1366 * 768 then
            dpi = 141 -- or whatever value you want for medium DPI screens (1080p laptops)
        else
            dpi = 110 --or whatever dpi value you want for low DPI screens
        end

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