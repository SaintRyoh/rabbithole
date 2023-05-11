local awful = require("awful")

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

            -- Add a titlebar if titlebars_enabled is set to true in the rules.
            client.connect_signal("request::titlebars", function(c)
                rabbithole__ui__default__titlebar(c)
            end)
        end)
    end,
})
