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
    return     {
        {
            {

                widget = wibox.widget.textbox,
                text = "test",
                id = "index_role"

            },

            left  = 18,
            right = 18,
            widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,
        -- Add support for hover colors and an index label
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            RC.debugger.dumpTable(index)
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            self:connect_signal('mouse::enter', function()
                -- self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
                if self.bg ~= '#ff0000' then
                    self.backup     = self.bg
                    self.has_backup = true
                end
                self.bg = '#ff0000'
            end)
            self:connect_signal('mouse::leave', function()
                if self.has_backup then self.bg = self.backup end
            end)
        end,
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            -- self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        end,
    }
end

return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })
