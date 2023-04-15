-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
    wallpaper = require("deco.wallpaper"),
}

local tasklist_buttons = require("deco.tasklist_buttons")()

return setmetatable({}, {
    __constructor = function(workspaceManagerService, workspaceMenu, taglist)
        awful.screen.connect_for_each_screen(function(s)
            -- Wallpaper
            set_wallpaper(s)

            workspaceManagerService:assignWorkspaceTagsToScreens()

            -- Require the separate wibar files
            local left_bar = require("src.interface.rabid-ui.left_bar")
            -- local center_bar = require("center_bar")
            -- local right_bar = require("right_bar")

            -- Create a promptbox for each screen
            s.mypromptbox = awful.widget.prompt()

            -- Create a layoutbox for each screen
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

            -- Create a textclock widget
            local mytextclock = wibox.widget.textclock()

            -- Create left wibox
            left_bar(s, {
                workspaceMenu,
                taglist(s),
                s.mypromptbox
            })

            -- Create center wibox
            -- center_bar(s, {
            --     s.mytasklist
            -- })

            -- Create right wibox
            -- right_bar(s, {
            --     awful.widget.keyboardlayout(),
            --     wibox.widget.systray(),
            --     mytextclock,
            --     s.mylayoutbox,
            -- })
        end)
    end,
})
