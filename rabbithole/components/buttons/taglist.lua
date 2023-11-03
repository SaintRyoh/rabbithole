-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local sharedtags = require("sub.awesome-sharedtags")
local __ = require("lodash")
-- }}}

return setmetatable({}, {
    __constructor = function (
        settings,
        workspaceManagerService,
        rabbithole__components__menus__taglist
    )
        local taglistmenu = rabbithole__components__menus__taglist
        -- Create a wibox for each screen and add it
        local taglist_buttons = gears.table.join(
                awful.button({ }, 1, function(t) -- clicked tag
                    local tag1 = t -- 1.3
                    local screen1 = tag1.screen -- bottom center

                    local screen2 = awful.screen.focused() -- left screen
                    local tag2 = __.first(screen2.selected_tags) -- 1.1

                    if screen1 == screen2  then
                        sharedtags.viewonly(tag1, screen1)
                    elseif not t.selected then
                        sharedtags.viewonly(tag1, screen2)
                    else
                        sharedtags.viewonly(tag1, screen2)
                        sharedtags.viewonly(tag2, screen1)
                    end

                end),
                awful.button({ settings.keys.modkey }, 3, function(t)
                    taglistmenu:updateMenu(t)
                    taglistmenu.taglist_menu:toggle()
                --    if client.focus then
                --        client.focus:move_to_tag(t)
                --    end
                end),
                awful.button({ "Control" }, 1, function(t)
                    sharedtags.viewtoggle(t, t.screen)
                end ),
                awful.button({ settings.keys.modkey }, 2, function(t)
                    workspaceManagerService:deleteTagFromWorkspaceWithConfirm(nil, t)
                end ),
                awful.button({ }, 4, function(t) workspaceManagerService:viewNextTag() end),
                awful.button({ }, 5, function(t) workspaceManagerService:viewPrevTag() end)
        )
        return taglist_buttons
        
    end
})