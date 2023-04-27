local wibox = require("wibox")
local awful = require("awful")

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
    -- return wibox.widget.textbox "Tasklist"
    return awful.widget.tasklist({
		screen = s,
        -- filter  = awful.widget.tasklist.filter.currenttags,
        filter  = generate_filter(tag),
		buttons = tasklist_buttons,
		widget_template = {
			{
				id = "clienticon",
				widget = awful.widget.clienticon,
			},
			layout = wibox.layout.stack,
			create_callback = function(self, c, _, _)
				self:get_children_by_id("clienticon")[1].client = c
				awful.tooltip({
					objects = { self },
					timer_function = function()
						return c.name
					end,
				})
			end,
		},
	})
end

return _M
