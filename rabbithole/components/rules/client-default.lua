local awful     = require("awful")
local gears     = require("gears")

-- reading
-- https://awesomewm.org/apidoc/libraries/awful.rules.html

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__keys__client, 
        rabbithole__components__buttons__client
    )
        local rules = {

            -- All clients will match this rule.
            { 
                rule = { },
                properties = {
                    focus     = awful.client.focus.filter,
                    raise     = false,
                    keys      = rabbithole__components__keys__client,
                    buttons   = rabbithole__components__buttons__client,
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
            
            -- Set window corner rounding to 5px
            {
                rule_any = {
                    type = { "normal", "dialog" }
                },
                callback = function(c)
                    gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 5)
                end
            },
            
            -- Round client window borders
            {
                rule_any = {
                    type = { "normal", "dialog" }
                },
                callback = function(c)
                    if c.round_corners then
                        return
                    end

                    c.shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, 10)
                    end

                    c.round_corners = true
                end
            },

            -- Clients with custom titlebars.
            {
                rule = {
                    requests_no_titlebar = true
                },
                properties = {
                    titlebars_enabled = false
                }
            },
        }
        return rules
    end
})
