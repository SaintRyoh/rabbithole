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



            -- Create a promptbox for each screen
            s.mypromptbox = awful.widget.prompt()
            --s.layoutlist = require("src.interface.widgets.layout_list")(s)

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
            
            -- Require the separate wibar files
            local rabid_bar = require("src.interface.rabid-ui.rabid_bar")
            local wonderland_ctlbar = require("src.interface.rabid-ui.wonderland_ctlbar")
            
            -- Create left wibox
            rabid_bar(s, {
                taglist(s),
                s.mypromptbox,
                s.mylayoutbox,
            })

            -- Create center wibox
            --center_bar(s, {
            --    s.mytasklist
            --})

            -- Create right wibox
            wonderland_ctlbar(s, {
                workspaceMenu,
                wibox.widget.systray(),
                mytextclock,
            })
        end)
    end,
})
