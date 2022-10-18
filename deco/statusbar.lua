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

local __ = require("lodash")
local sharedtags = require("awesome-sharedtags")

local workspaces = RC.workspaces
local naughty = require("naughty")
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

local workspace_menu = nil

function rename_workspace(workspace)
    awful.prompt.run {
        prompt       = "Rename workspace: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            if not workspace then return end
            workspace.name = new_name
            workspace_menu = generate_menu()
            naughty.notify({
                title="rename workspace",
                text="workspace renamed to: " .. workspace.name,
                timeout=0
            })
        end
    }
end

function generate_menu()
    local menu = awful.menu({
        items = gears.table.join(__.map(workspaces:getAllWorkspaces(),
                function(workspace, index)
                    return {
                        workspace.name or "workspace: " .. index,
                        {
                            { "switch", function()  switch_to_workspace(workspace) end},
                            { "rename", function() rename_workspace(workspace) end},
                            { "remove", function()  remove_workspace(workspace) end}
                        }
                    }
                end))
    })
    menu:add({ "add workspace", function () add_workspace() end})
    return menu
end

function switch_to_workspace(workspace)
    workspaces:switchTo(workspace)
end

function remove_workspace(workspace)
    -- if the workspace if active don't delete it
    if workspace:getStatus() then
        naughty.notify({
            title="switch to another workspace before removing it",
            text=string.format("workspace id: %d ", workspace_id),
            timeout=0
        })
        return
    end
    -- First Delete all the tags and their clients in the workspace
    __.forEach(workspace:getAllTags(),
            function(tag)
                __.forEach(tag:clients(), function(client) client:kill() end)
                tag:delete()
            end)
    -- Then Delete workspace
    workspaces:deleteWorkspace(workspace)
    -- regenerate menu
    workspace_menu = generate_menu()

    naughty.notify({
        title="removed workspace",
        timeout=0
    })
end

function add_workspace()
    local workspace = workspaces:createWorkspace()
    workspaces:switchTo(workspace)
    workspace_menu = generate_menu()

    naughty.notify({
        title="added workspace",
        timeout=0
    })
    --
    setup_tags()
end

function setup_tags()
    for s in screen do
        setup_tags_on_screen(s)
    end
end


function setup_tags_on_screen(s)

    local all_active_workspaces = workspaces:getAllActiveWorkspaces()
    local all_tags = __.flatten(__.map(all_active_workspaces, function(workspace) return workspace:getAllTags() end))
    local unselected_tags = __.filter(all_tags, function(tag) return not tag.selected end)

    naughty.notify({
        title="setup tags",
        text=string.format([[ clients: %d, root tags: %d, Screen Index: %d; All workspaces count: %d, all active workspaces: %d; tags: %s;
     unselected: %d]],
            #client.get(), #root.tags(), s.index, #workspaces:getAllWorkspaces(), #all_active_workspaces, #all_tags, #unselected_tags ),
        timeout=0
    })
    local tag = __.first(unselected_tags)

    if tag then
        naughty.notify({
        title="setup tags",
        text="recycling tag:" .. tag.name,
        timeout=0
        })
    end

    -- if not, then make one
    if not tag then
        local last_workspace = __.last(all_active_workspaces) or __.first(workspaces:getAllWorkspaces())
        tag = sharedtags.add(#workspaces:getAllWorkspaces() .. "." .. #last_workspace:getAllTags()+1, { layout = awful.layout.layouts[2] })
        last_workspace:addTag(tag)
        last_workspace:setStatus(true)
        naughty.notify({
        title="setup tags",
        text="making new tag:" .. tag.name .. " for screen:" .. s.index,
        timeout=0
        })
    end

    sharedtags.viewonly(tag, s)

end



awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    --     end

    -- tag setup
    setup_tags_on_screen(s)


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




    ---------------- selector -------------------------


    workspace_menu = generate_menu()



    local dropdownmenu = {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.widget.textbox,
            text = "   workspace: X   ",
            buttons = gears.table.join(
                    awful.button({ }, 1,
                            function ()
                                workspace_menu:toggle()
                            end)
            )
        }
    }


    ---------------- end -------------------------



    -- Add widgets to the wibox
    s.mywibar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            RC.launcher,
            dropdownmenu,
            s.mytaglist,
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
end)
-- }}}
