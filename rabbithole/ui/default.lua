local awful     = require("awful")

return setmetatable({}, {
    __constructor = function(
        workspaceManagerService, 
        rabbithole__wibox__default___bars__left, 
        rabbithole__wibox__default___bars__center, 
        rabbithole__wibox__default___bars__right,
        rabbithole__wallpaper
    )
        awful.screen.connect_for_each_screen(function(s)

            -- if workspaceManagerService.session_restored ~= true then
            workspaceManagerService:assignWorkspaceTagsToScreens()
            --     workspaceManagerService.session_restored = true
            -- end

            rabbithole__wibox__default___bars__left(s)
            rabbithole__wibox__default___bars__center(s)
            rabbithole__wibox__default___bars__right(s)


        end)
    end,
})