-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local sharedtags = require("sub.awesome-sharedtags")
local __ = require("lodash")
local modal = require("rabbithole.components.wiboxes.modal.modal")
-- }}}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get(_taglistmenu, workspaceManagerService)
    local taglistmenu = _taglistmenu
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
            awful.button({ "Mod4" }, 1, function(t)
                taglistmenu:updateMenu(t)
                taglistmenu.taglist_menu:toggle()
            --    if client.focus then
            --        client.focus:move_to_tag(t)
            --    end
            end),
            awful.button({ }, 3, function(t)
                sharedtags.viewtoggle(t, t.screen)
            end ),
            awful.button({ }, 2, function(t)
                modal.confirm({
                    title = "Delete tag",
                    text = "Are you sure you want to delete this tag?",
                    yes_callback = function()
                        workspaceManagerService:deleteTagFromWorkspace(nil, t)
                    end
                }):show()
            end )
            --awful.button({ modkey }, 3, function(t)
            --    if client.focus then
            --        client.focus:toggle_tag(t)
            --    end
            --end),
            --awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
            --awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

    return taglist_buttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, taglistmenu, workspaceManagerService) return _M.get(taglistmenu, workspaceManagerService) end })
