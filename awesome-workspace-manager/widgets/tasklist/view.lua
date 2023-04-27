local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local _M = {}
local generate_filter = function(t)
    return function(c, scr)
        local ctags = c:tags()
        for _, v in ipairs(ctags) do
            if v == t then
                return true
            end
        end
        return false
    end
end

function _M.create(tasklist_buttons, s, tag)
    return wibox.widget {
        {
            awful.widget.tasklist({
                screen = s,
                filter  = generate_filter(tag),
                buttons = tasklist_buttons,
                widget_template = {
                    {
                        {
                            {
                                id = "clienticon",
                                widget = wibox.widget.imagebox,
                                forced_width = 24,
                                forced_height = 24,
                            },
                            widget = wibox.container.margin,
                            margins = 3,
                        },
                        id = 'background_role',
                        widget = wibox.container.background,
                    },
                    layout = wibox.layout.stack,
                    create_callback = function(self, c, _, _)
                        if c.icon then
                            self:get_children_by_id("clienticon")[1].image = c.icon
                        else
                            self:get_children_by_id("clienticon")[1].image = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "themes/rabbithole/icons/fallback.svg")
                        end

                        self:connect_signal('mouse::enter', function()
                            self:get_children_by_id('background_role')[1]:set_bg(beautiful.bg_focus)
                            self:get_children_by_id('background_role')[1]:set_fg(beautiful.bg_focus)
                        end)
                        self:connect_signal('mouse::leave', function()
                            self:get_children_by_id('background_role')[1]:set_bg('#00000000')
                            self:get_children_by_id('background_role')[1]:set_fg('#00000000')
                        end)

                        awful.tooltip({
                            objects = { self },
                            timer_function = function()
                                return c.name
                            end,
                        })
                    end,
                },
            }),
            widget = wibox.container.background,
            bg = beautiful.tasklist_bg_normal,
            shape = gears.shape.rounded_rect,
            shape_border_width = 1,
            shape_border_color = beautiful.tasklist_bg_normal,
        },
        layout = wibox.layout.fixed.horizontal,
    }
end

return _M
