-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
    wallpaper = require("deco.wallpaper"),
    taglist   = require("deco.taglist"),
    tasklist  = require("deco.tasklist")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

local ft = require("std.functional")
local __ = require("lodash")
local sharedtags = require("awesome-sharedtags")

local workspaces = RC.workspaces

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Assign tags to the newly connected screen here,
    -- if desired:
    local unselected_tags
    local func_get_unselected_tags = ft.compose(

            function(all_active_workspaces)
                return __.flatten(__.map(all_active_workspaces,
            function(workspace)
                        return workspace:getAllTags()
                    end
                ))
            end,

            function(_all_tags)
                all_tags = _all_tags
                return __.filter(_all_tags,
        function(tag)
                        return tag.activated
                    end)
            end,

            function(all_active_tags)
                return __.filter(all_active_tags,
        function(tag)
                        return not tag.selected
                    end
                )
            end
    ) workspaces:getAllActiveWorkspaces()

    unselected_tags = func_get_unselected_tags()

    local tag = __.first(unselected_tags)

    if not tag then
        tag = sharedtags.add(s.index, { layout = awful.layout.layouts[2] })
        local last_workspace = __.last(workspaces:getAllActiveWorkspaces()) or __.first(workspaces:getAllWorkspaces())
        last_workspace:addTag(tag)
    end

    sharedtags.viewonly(tag, s)

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

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibar = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            RC.launcher,
            s.mytaglist,
            s.mypromptbox,
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
end)
-- }}}
