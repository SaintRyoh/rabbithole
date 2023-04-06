local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local __ = require("lodash")
local color = require("src.themes.rabbithole.colors")


local _M = {}

function _M.get(controller)
    -- RC.debugger.dbg()
    return {
        id     = 'background_role',
        widget = wibox.container.background,
        {
            left  = 18,
            right = 18,
            widget = wibox.container.margin
            {
                widget = wibox.widget.textbox,
                text = "test",
                id = "index_role"
            },
        },

        -- Add support for hover colors and an index label
        create_callback = function(self, tag, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            self.bg = beautiful.bg_focus
            self:connect_signal('mouse::enter', function()
                self.bg = '#ff0000'
            end)
            self:connect_signal('mouse::leave', function()
                if tag.selected then
                    self.bg = beautiful.bg_focus
                else
                    self.bg = beautiful.bg_normal
                end
            end)
        end,

        update_callback = function(self, tag, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            if tag.selected then
                self.bg = beautiful.bg_focus
            else
                self.bg = beautiful.bg_normal
            end
        end,
    }
end

return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })
