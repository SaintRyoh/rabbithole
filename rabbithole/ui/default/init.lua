local awful     = require("awful")

return setmetatable({}, {
    __constructor = function(
        workspaceManagerService, 
        rabbithole__ui__default__left, 
        rabbithole__ui__default__center, 
        rabbithole__ui__default__right,
        rabbithole__services__wallpaper
    )
        awful.screen.connect_for_each_screen(function(s)

            -- if workspaceManagerService.session_restored ~= true then
            workspaceManagerService:assignWorkspaceTagsToScreens()
            --     workspaceManagerService.session_restored = true
            -- end
            rabbithole__services__wallpaper.set_wallpaper(s)

            rabbithole__ui__default__left(s)
            rabbithole__ui__default__center(s)
            rabbithole__ui__default__right(s)


        end)
    end,
})