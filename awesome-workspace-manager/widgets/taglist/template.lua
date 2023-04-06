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
            widget = wibox.container.margin,
            {
                widget = wibox.widget.textbox,
                text = "test",
                id = "index_role"
            },
        },

        -- Add support for hover colors and an index label
        create_callback = function (tag_template, tag, index, objects) controller:create_tag_callback(tag_template, tag, index, objects) end,

        update_callback = function (tag_template, tag, index, objects) controller:update_tag_callback(tag_template, tag, index, objects) end,
    }
end

return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })
