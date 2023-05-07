-- Standard awesome library
local awful     = require("awful")
-- Theme handling library
local beautiful = require("beautiful")

local _M = {}

-- reading
-- https://awesomewm.org/apidoc/libraries/awful.rules.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return setmetatable({}, {
    __constructor = function(
        rabbithole__components__keys__client, 
        rabbithole__components__buttons__client
    )
        local clientkeys = rabbithole__components__keys__client
        local clientbuttons = rabbithole__components__buttons__client
        local rules = {

            -- All clients will match this rule.
            { 
                rule = { },
                properties = {
                    border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus     = awful.client.focus.filter,
                    raise     = true,
                    keys      = clientkeys,
                    buttons   = clientbuttons,
                    screen    = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
                }
            },

            -- Floating clients.
            { 
                rule_any = {
                    instance = {
                        "DTA",  -- Firefox addon DownThemAll.
                        "copyq",  -- Includes session name in class.
                        "pinentry",
                    },
                    class = {
                        "Arandr",
                        "Blueman-manager",
                        "Gpick",
                        "Kruler",
                        "MessageWin",  -- kalarm.
                        "Sxiv",
                        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                        "Wpa_gui",
                        "veromix",
                        "xtightvncviewer"
                    },

                    -- Note that the name property shown in xprop might be set slightly after creation of the client
                    -- and the name shown there might not match defined rules here.
                    name = {
                        "Event Tester",  -- xev.
                    },
                    role = {
                        "AlarmWindow",  -- Thunderbird's calendar.
                        "ConfigManager",  -- Thunderbird's about:config.
                        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                    }
                },
                properties = {
                    floating = true
                }
            },

            -- Add titlebars to normal clients and dialogs
            { 
                rule_any = {
                    type = { "normal", "dialog" }
                },
                properties = {
                    titlebars_enabled = true
                }
            },

            -- no titlebars for launchers
            { 
                rule_any = {
                    class = {
                        "dmenu",
                        "rofi",
                        "lxqt-runner",
                    }
                },
                properties = {
                    titlebars_enabled = false,
                    placement = awful.placement.centered,
                    skip_taskbar = true,
                    floating = true,
                    ontop = true,
                    sticky = true,
                }
            },

        }
        return rules
    end
})