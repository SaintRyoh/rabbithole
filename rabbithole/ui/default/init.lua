local awful = require("awful")
local beautiful = require("beautiful")

return setmetatable({}, {
    __constructor = function(
        workspaceManagerService,
        rabbithole__ui__default__left,
        rabbithole__ui__default__center,
        rabbithole__ui__default__right,
        rabbithole__ui__default__titlebar
    )
        awful.screen.connect_for_each_screen(function(s)
            -- if workspaceManagerService.session_restored ~= true then
            workspaceManagerService:assignWorkspaceTagsToScreens()
            --     workspaceManagerService.session_restored = true
            -- end

            -- rabbithole__services__wallpaper.set_wallpaper(s)

            -- wibars
            rabbithole__ui__default__left(s)
            rabbithole__ui__default__center(s)
            rabbithole__ui__default__right(s)

            -- set dpi of screens
            local resolution = s.geometry.width * s.geometry.height
            local dpi
            print("s.dpi: " .. s.dpi)
            if resolution > 1920 * 1080 then
                dpi = 144 -- or whatever value you want for high DPI screens
            else
                dpi = 96 --or whatever dpi value you want for low DPI screens
            end
            beautiful.xresources.set_dpi(dpi, s)

            -- Add a titlebar if titlebars_enabled is set to true in the rules.
            client.connect_signal("request::titlebars", function(c)
                rabbithole__ui__default__titlebar(c)
            end)
        end)
    end,
})
