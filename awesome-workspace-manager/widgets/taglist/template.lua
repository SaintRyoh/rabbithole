local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local __ = require("lodash")

local _M = {}

function _M.get(controller)
    local Template = { }
    
    Template.root = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        bind = "root",
        signals = {
            ["mouse::enter"] = function(widget, bindings)
                widget.bg = beautiful.bg_focus
            end,

            ["mouse::leave"] = function(widget, bindings)
                widget.bg = beautiful.bg_normal
            end
        },
        {
            widget = wibox.container.margin,
            margins = 3,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    text = "initial text",
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox,
                    bind = "textbox"
                },
            }
        },
    }

    return Template

end



return setmetatable({}, { __call = function(_, controller) return _M.get(controller) end })