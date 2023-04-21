-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")
-- Wibox handling library
local wibox = require("wibox")
local beautiful = require("beautiful")



local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local tasklist_buttons = require("deco.tasklist_buttons")()

return setmetatable({}, {
    __constructor = function(
        workspaceManagerService, 
        workspaceMenu, 
        taglist, 
        awesome___workspace___manager__wibox__bars__left, 
        awesome___workspace___manager__wibox__bars__center, 
        awesome___workspace___manager__wibox__bars__right
    )
        awful.screen.connect_for_each_screen(function(s)
            -- Wallpaper
            set_wallpaper(s)
            --     end

            -- if workspaceManagerService.session_restored ~= true then
            workspaceManagerService:assignWorkspaceTagsToScreens()
            --     workspaceManagerService.session_restored = true
            -- end


            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            s.mylayoutbox = awful.widget.layoutbox(s)
            s.mylayoutbox:buttons(gears.table.join(
                    awful.button({ }, 1, function () awful.layout.inc( 1) end),
                    awful.button({ }, 3, function () awful.layout.inc(-1) end),
                    awful.button({ }, 4, function () awful.layout.inc( 1) end),
                    awful.button({ }, 5, function () awful.layout.inc(-1) end)
            ))

            -- Create a tasklist widget
            s.mytasklist = awful.widget.tasklist {
                screen  = s,
                filter  = awful.widget.tasklist.filter.currenttags,
                buttons = tasklist_buttons
            }

            local mytextclock = wibox.widget.textclock()

            s.leftbar = awesome___workspace___manager__wibox__bars__left(s)
            s.center = awesome___workspace___manager__wibox__bars__center(s)
            s.rightbar = awesome___workspace___manager__wibox__bars__right(s)

            s.leftbar:setup {
                layout = wibox.layout.align.horizontal,
                workspaceMenu
            }

            s.center:setup {
                layout = wibox.layout.align.horizontal,
                taglist(s),
                s.mytasklist,
            }

            s.rightbar:setup {
                layout = wibox.layout.fixed.horizontal,
                awful.widget.keyboardlayout(),
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox,
            }

        end)
    end,
})