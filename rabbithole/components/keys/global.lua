-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local sharedtags = require("sub.awesome-sharedtags")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")


local _M = {} -- TO RYOH: Idk why this is here, if its not needed anymore, remove it.

-- documentation
-- https://awesomewm.org/wiki/Global_Keybindings

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __constructor = function(workspaceManagerService, settings, rabbithole__components__menus__main)
        -- Resource Configuration
        local modkey = settings.keys.modkey or "Mod4"
        local altkey = settings.keys.altkey or "Mod1"
        local mainmenu = rabbithole__components__menus__main
        local terminal = settings.default_programs.terminal
        local launcher = settings.default_programs.launcher_cmd
        local window_switcher = settings.default_programs.window_switcher_cmd
        local globalkeys = gears.table.join(

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Hotkeys Help
            awful.key({ modkey, }, "h", hotkeys_popup.show_help,
                { description = "Show help", group = "awesome" }),

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
            awful.key({ modkey, }, "Left", function() workspaceManagerService:viewPrevTag() end,
                { description = "view previous", group = "tag" }),
            awful.key({ modkey, }, "Right", function() workspaceManagerService:viewNextTag() end,
                { description = "view next", group = "tag" }),
            awful.key({ modkey, }, "Escape", awful.tag.history.restore,
                { description = "go back", group = "tag" }),

            --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- client focus
            awful.key({ modkey, }, "j",
                function() awful.client.focus.byidx(1) end,
                { description = "focus next by index", group = "client" }),
            awful.key({ modkey, }, "k",
                function() awful.client.focus.byidx(-1) end,
                { description = "focus previous by index", group = "client" }),
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
            --awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
            --    { description = "increase master width factor", group = "layout" }),
            --awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
            --    { description = "decrease master width factor", group = "layout" }),
            --awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
            --    { description = "increase the number of master clients", group = "layout" }),
            --awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
            --    { description = "decrease the number of master clients", group = "layout" }),
            --awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
            --    { description = "increase the number of columns", group = "layout" }),
            --awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
            --    { description = "decrease the number of columns", group = "layout" }),
            --awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
            --    { description = "select next", group = "layout" }),
            --awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
            --    { description = "select previous", group = "layout" }),

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
            -- Applications
            awful.key({ modkey }, "r",
                function() os.execute(launcher) end,
                { description = "run rofi", group = "Applications" }),
            -- press mod4 to open rofi window switcher
            awful.key({ modkey }, "Tab",
                function()
                    os.execute(window_switcher)
                end,
                { description = "show window switcher", group = "launcher" }),

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

            -- quake style dropdown terminal bound to mod4 + \
            awful.key({ modkey }, "\\", function () awful.screen.focused().dropdown:toggle() end, {description = "dropdown application", group = "launcher"}),

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
            -- Special Keys

            --  Brightness Keys
            awful.key({ }, "XF86MonBrightnessUp",
                function() awful.spawn(settings.default_programs.brightness_up) end,
                { description = "increase brightness", group = "hotkeys" }),
            awful.key({}, "XF86MonBrightnessDown",
                function() awful.spawn(settings.default_programs.brightness_down) end,
                { description = "decrease brightness", group = "hotkeys" }),
            awful.key({}, "XF86Display",
                function() awful.spawn(settings.default_programs.screen_config) end,
                { description = "Open Screen Configuration", group = "hotkeys" }),

            --  Volume Keys
            awful.key({ }, "XF86AudioRaiseVolume",
                function() awful.spawn(settings.default_programs.volume_up) end,
                { description = "increase volume", group = "hotkeys" }),
            awful.key({}, "XF86AudioLowerVolume",
                function() awful.spawn(settings.default_programs.volume_down) end,
                { description = "decrease volume", group = "hotkeys" }),
            awful.key({}, "XF86AudioMute",
                function() awful.spawn(settings.default_programs.volume_mute_toggle) end,
                { description = "volume toggle", group = "hotkeys" }),
            awful.key({}, "XF86AudioMicMute",
                function() awful.spawn(settings.default_programs.mic_mute_toggle) end,
                { description = "mic toggle", group = "hotkeys" }),

            --  Screenshot Tool
            awful.key({ }, "Print", function() awful.spawn(settings.default_programs.screenshot_tool) end,
                { description = "Screenshot Tool", group = "hotkeys" }),

            --  Wifi antenna Toggle comment out if nm-applet is used
            -- awful.key({ }, "XF86WLAN", function() awful.with_shell(settings.default_programs.wifi_radio_toggle) end,
            --     { description = "Convert OCR image to text and copy to clipboard", group = "hotkeys" }),

            -- Keybinding to toggle titlebar visibility
            awful.key({ modkey }, "t", function() awful.titlebar.toggle(client.focus) end,
                { description = "toggle titlebar", group = "client" })
        )

        local function getWorkspaceAndTag(index)
            local workspace = workspaceManagerService:getActiveWorkspace()
            local tags = workspace:getAllTags()
            return workspace, tags[index]
        end

        for i = 1, 9 do -- Lua's indexing starts at 1
            globalkeys = gears.table.join(globalkeys,
                awful.key({ modkey }, tostring(i), 
                    function()
                        local workspace, tag = getWorkspaceAndTag(i)
                        if tag then
                            sharedtags.viewonly(tag, awful.screen.focused())
                        else
                            workspaceManagerService:addTagToWorkspace(workspace)
                        end
                    end,
                    { description = "view tag #" .. i, group = "tag" }
                ),
                awful.key({ modkey, "Control" }, tostring(i), 
                    function()
                        local _, tag = getWorkspaceAndTag(i)
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end,
                    { description = "toggle tag #" .. i, group = "tag" }
                ),
                -- switch to global tag by index
                awful.key({ modkey, altkey }, tostring(i),
                    function()
                        local global_tag = awful.screen.focused().tags[i]
                        if global_tag then
                            sharedtags.viewtoggle(global_tag, awful.screen.focused())
                        else
                            naughty.notify({ title = "No global tag #" .. i, preset = naughty.config.presets.critical })
                        end
                    end,
                    { description = "switch to global tag #" .. i, group = "tag" }
                ),
                awful.key({ modkey, "Shift" }, tostring(i),
                    function() 
                        local _, tag = getWorkspaceAndTag(i)
                        if client.focus and tag then
                            client.focus:move_to_tag(tag)
                            tag:view_only()
                        end
                    end,
                    { description = "move focused client to tag #" .. i, group = "tag" }
                ),
                awful.key({ modkey, "Control", "Shift" }, tostring(i),
                    function()
                        local _, tag = getWorkspaceAndTag(i)
                        if client.focus and tag then
                            client.focus:toggle_tag(tag)
                        end
                    end,
                    { description = "toggle focused client on tag #" .. i, group = "tag" }
                )
                -- The swap function would still need to be addressed separately as mentioned earlier.
            )
        end

        return globalkeys
    end,
})
