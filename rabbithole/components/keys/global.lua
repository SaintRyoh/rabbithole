-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local sharedtags = require("sub.awesome-sharedtags")

-- local hotkeys_popup = require("awful.hotkeys_popup").widget
local hotkeys_popup = require("awful.hotkeys_popup")
-- Menubar library
local menubar = require("menubar")
local __ = require("lodash")



local _M = {}

-- reading
-- https://awesomewm.org/wiki/Global_Keybindings

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __constructor = function(workspaceManagerService, settings, rabbithole__components__menus__main)
        -- Resource Configuration
        local modkey = settings.modkey
        local mainmenu = rabbithole__components__menus__main
        local terminal = settings.terminal
        local globalkeys = gears.table.join(
            awful.key({ modkey, }, "s", hotkeys_popup.show_help,
                { description = "show help", group = "awesome" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Dynamic tagging
            awful.key({ modkey, "Shift" }, "n", function() workspaceManagerService:addTagToWorkspace() end,
                { description = "add new tag", group = "tag" }),
            awful.key({ modkey, "Shift" }, "r", function() workspaceManagerService:renameTag() end,
                { description = "rename tag", group = "tag" }),
            awful.key({ modkey, "Shift" }, "Left", function() workspaceManagerService:moveTag(-1) end,
                { description = "move tag to the left", group = "tag" }),
            awful.key({ modkey, "Shift" }, "Right", function() workspaceManagerService:moveTag(1) end,
                { description = "move tag to the right", group = "tag" }),
            awful.key({ modkey, "Shift" }, "d", function() workspaceManagerService:deleteTagFromWorkspace() end,
                { description = "delete tag", group = "tag" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Tag browsing
            awful.key({ modkey, }, "Left", awful.tag.viewprev,
                { description = "view previous", group = "tag" }),
            awful.key({ modkey, }, "Right", awful.tag.viewnext,
                { description = "view next", group = "tag" }),
            awful.key({ modkey, }, "Escape", awful.tag.history.restore,
                { description = "go back", group = "tag" }),
            awful.key({ modkey, }, "j",
                function()
                    awful.client.focus.byidx(1)
                end,
                { description = "focus next by index", group = "client" }
            ),
            awful.key({ modkey, }, "k",
                function()
                    awful.client.focus.byidx(-1)
                end,
                { description = "focus previous by index", group = "client" }
            ),
            awful.key({ modkey, }, "w", function() mainmenu:show() end,
                { description = "show main menu", group = "awesome" }),


            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Layout - Client index manipulation & screen focus
            awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
                { description = "swap with next client by index", group = "client" }),
            awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
                { description = "swap with previous client by index", group = "client" }),
            awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
                { description = "focus the next screen", group = "screen" }),
            awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
                { description = "focus the previous screen", group = "screen" }),
            awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
                { description = "jump to urgent client", group = "client" }),
            awful.key({ modkey, }, "Tab",
                function()
                    awful.client.focus.history.previous()
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                { description = "go back", group = "client" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Standard program
            awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
                { description = "open a terminal", group = "launcher" }),
            awful.key({ modkey, "Control" }, "r", awesome.restart,
                { description = "reload awesome", group = "awesome" }),
            awful.key({ modkey, "Shift" }, "q", awesome.quit,
                { description = "quit awesome", group = "awesome" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Layout manipulation
            awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
                { description = "increase master width factor", group = "layout" }),
            awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
                { description = "decrease master width factor", group = "layout" }),
            awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
                { description = "increase the number of master clients", group = "layout" }),
            awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
                { description = "decrease the number of master clients", group = "layout" }),
            awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
                { description = "increase the number of columns", group = "layout" }),
            awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
                { description = "decrease the number of columns", group = "layout" }),
            awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
                { description = "select next", group = "layout" }),
            awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
                { description = "select previous", group = "layout" }),

            awful.key({ modkey, "Control" }, "n",
                function()
                    local c = awful.client.restore()
                    -- Focus restored client
                    if c then
                        c:emit_signal(
                            "request::activate", "key.unminimize", { raise = true }
                        )
                    end
                end,
                { description = "restore minimized", group = "client" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Prompt
            awful.key({ modkey }, "r", function() os.execute("lxqt-runner") end,
                { description = "run lxqt-runner", group = "launcher" }),
            awful.key({ modkey }, "d",
                function()
                    os.execute("rofi -show run -font \"Ubuntu 13\" -icon-theme \"BeautyLine\" -show-icons")
                end,
                {
                    description = "run rofi",
                    group       = "launcher"
                }),

            awful.key({ modkey }, "x",
                function()
                    awful.prompt.run {
                        prompt       = "Run Lua code: ",
                        textbox      = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                    }
                end,
                { description = "lua execute prompt", group = "awesome" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Resize
            --awful.key({ modkey, "Control" }, "Left",  function () awful.client.moveresize( 20,  20, -40, -40) end),
            --awful.key({ modkey, "Control" }, "Right", function () awful.client.moveresize(-20, -20,  40,  40) end),
            awful.key({ modkey, "Control" }, "Down",
                function() awful.client.moveresize(0, 0, 0, -20) end),
            awful.key({ modkey, "Control" }, "Up",
                function() awful.client.moveresize(0, 0, 0, 20) end),
            awful.key({ modkey, "Control" }, "Left",
                function() awful.client.moveresize(0, 0, -20, 0) end),
            awful.key({ modkey, "Control" }, "Right",
                function() awful.client.moveresize(0, 0, 20, 0) end),

            -- Move
            awful.key({ modkey, "Shift" }, "Down",
                function() awful.client.moveresize(0, 20, 0, 0) end),
            awful.key({ modkey, "Shift" }, "Up",
                function() awful.client.moveresize(0, -20, 0, 0) end),
            awful.key({ modkey, "Shift" }, "Left",
                function() awful.client.moveresize(-20, 0, 0, 0) end),
            awful.key({ modkey, "Shift" }, "Right",
                function() awful.client.moveresize(20, 0, 0, 0) end),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Menubar
            awful.key({ modkey }, "p", function() menubar.show() end,
                { description = "show the menubar", group = "launcher" }),

            -- Screen brightness up & down with xbacklight
            awful.key({ }, "XF86MonBrightnessUp",
                function () awful.util.spawn("xbacklight -inc 10", false) end,
                {description = "increase brightness", group = "hotkeys"}),
            awful.key({ }, "XF86MonBrightnessDown",
                function () awful.util.spawn("xbacklight -dec 10", false) end,
                {description = "decrease brightness", group = "hotkeys"}),
            -- Keybinding to toggle titlebar visibility
            awful.key({ modkey }, "t", function() awful.titlebar.toggle(client.focus) end,
                { description = "toggle titlebar", group = "client" })
        )
        -- For loop to add number row of keyboard to global keybindings. Workspace, tag, & client
        for i = 1, 9 do -- Lua's indexing starts at 1
            local workspace = workspaceManagerService:getActiveWorkspace()
            local tags = workspace:getAllTags()
            local tag = tags[i]

            globalkeys = gears.table.join(globalkeys,
                -- View tag only.
                awful.key({ modkey }, "#" .. i + 9,
                    function()
                        if tag then
                            sharedtags.viewonly(tag)
                        else
                            workspaceManagerService:addTagToWorkspace(workspace)
                        end
                    end,
                    { description = "view tag #" .. i, group = "tag" }),
                -- Toggle tag display on/off
                awful.key({ modkey, "Control" }, "#" .. i + 9,
                    function()
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end,
                    { description = "toggle tag #" .. i, group = "tag" }),
                -- Move client to tag by index.
                awful.key({ modkey, "Shift" }, "#" .. i + 9,
                    function()
                        if client.focus and tag then
                            client.focus:move_to_tag(tag)
                        end
                    end,
                    { description = "move focused client to tag #" .. i, group = "tag" }),
                -- Toggle focused client on tag.
                awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                    function()
                        if client.focus and tag then
                            client.focus:toggle_tag(tag)
                        end
                    end,
                    { description = "toggle focused client on tag #" .. i, group = "tag" }),
                -- Swap tags by index.
                awful.key({ modkey, "Control", "Alt_L" }, "#" .. i + 9,
                    function()
                        local current_tag_index = awful.screen.focused().selected_tag.index
                        workspaceManagerService:swapTagsByIndex(current_tag_index, i)
                    end,
                    { description = "swap tags by index " .. i, group = "tag" })
            )
        end

        return globalkeys
    end,
})
