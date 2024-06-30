local awful = require("awful")
local gears = require("gears")

-- reading
-- https://awesomewm.org/apidoc/libraries/awful.rules.html
-- https://awesomewm.org/doc/api/libraries/awful.rules.html

local Rules = {}
Rules.__index = Rules

function Rules.new(
    rabbithole__components__keys__client,
    rabbithole__components__buttons__client
)
    return {
        -- All clients will match this rule.
        {
            rule = {},
            properties = {
                titlebars_enabled = true,
                focus = awful.client.focus.filter,
                raise = false,
                keys = rabbithole__components__keys__client,
                buttons = rabbithole__components__buttons__client,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen
            }
        },
        -- Dialogs
        {
            rule = {
                type = "dialog"
            },
            properties = {
                titlebars_enabled = true,
                skip_taskbar = true,
                floating = true,
                ontop = true
            }
        }, 
        -- Launchers
        {
            rule_any = {
                class = {"dmenu", "rofi", "lxqt-runner", "qterminal"},
            },
            except = {
                type = "normal"
            },
            properties = {
                titlebars_enabled = false,
                placement = awful.placement.centered,
                sticky = true
            }
        },
        -- Clients with custom titlebars.
        {
            rule = {
                requests_no_titlebar = true
            },
            -- Clients with custom titlebars
            {
                rule = {
                    requests_no_titlebar = true
                },
                properties = {
                    titlebars_enabled = false
                }
            }
        }
    }
end

return Rules
