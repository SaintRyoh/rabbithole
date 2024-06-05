local awful = require("awful")
local gears = require("gears")

-- reading
-- https://awesomewm.org/apidoc/libraries/awful.rules.html

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__keys__client,
        rabbithole__components__buttons__client,
        settings
    )
        local rules = {
            -- All clients will match this rule.
            {
                rule = {},
                properties = {
                    focus = awful.client.focus.filter,
                    raise = false,
                    keys = rabbithole__components__keys__client,
                    buttons = rabbithole__components__buttons__client,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                    titlebars_enabled = settings.ui_opt.titlebars
                }
            },
            -- Dialogs and popups should have titlebars enabled
            {
                rule_any = {
                    type = { "dialog", "modal", "utility" },
                    class = { "Dmenu", "Rofi", "lxqt-runner" }
                },
                properties = {
                    titlebars_enabled = true
                }
            },
            -- No titlebars for terminal (alacritty)
            {
                rule_any = {
                    class = { "Alacritty" }
                },
                properties = {
                    titlebars_enabled = false
                }
            },
            -- No titlebars for kitty terminal
            {
                rule_any = {
                    class = { "kitty" }
                },
                properties = {
                    titlebars_enabled = false
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
        return rules
    end
})
