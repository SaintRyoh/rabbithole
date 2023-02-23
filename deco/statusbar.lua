-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")
-- Wibox handling library
local wibox = require("wibox")



local workspaceManagerService = RC.workspaceManagerService

-- Custom Local Library: Common Functional Decoration
local deco = {
    wallpaper = require("deco.wallpaper"),
    tasklist  = require("deco.tasklist"),
}

local workspaceMenu = require("awesome-workspace-manager.widgets.workspace-menu")
local taglist = require("awesome-workspace-manager.widgets.taglist")

local tasklist_buttons = deco.tasklist()

local __ = require("lodash")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    --     end

    -- tag setup
    workspaceManagerService:setupTagsOnScreen(s)


-- {{{ Wibar
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
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

    -- Create the wibox
    s.mywibar = awful.wibar({ position = "top", screen = s })



    -- Create a textclock widget
    local mytextclock = wibox.widget.textclock()

    -- Add widgets to the wibox
    s.mywibar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            RC.launcher,
            workspaceMenu(workspaceManagerService),
            taglist(workspaceManagerService, s),
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
-- }}}
end)
