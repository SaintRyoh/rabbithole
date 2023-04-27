local awful     = require("awful")

return setmetatable({}, {
    __constructor = function(
        workspaceManagerService, 
        awesome___workspace___manager__wibox__default___bars__left, 
        awesome___workspace___manager__wibox__default___bars__center, 
        awesome___workspace___manager__wibox__default___bars__right,
        awesome___workspace___manager__wallpaper
    )
        awful.screen.connect_for_each_screen(function(s)

            -- if workspaceManagerService.session_restored ~= true then
            workspaceManagerService:assignWorkspaceTagsToScreens()
            --     workspaceManagerService.session_restored = true
            -- end

            awesome___workspace___manager__wibox__default___bars__left(s)
            awesome___workspace___manager__wibox__default___bars__center(s)
            awesome___workspace___manager__wibox__default___bars__right(s)


        end)
    end,
})