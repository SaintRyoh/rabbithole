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
            else
                dpi = 96 --or whatever dpi value you want for low DPI screens
            end

            beautiful.xresources.set_dpi(dpi, s)
        end)
    end,
})
