local wibox = require("wibox")
local beautiful = require("beautiful")
local __ = require("lodash")
local naughty = require("naughty")

local PlusButton = {}
PlusButton.__index = PlusButton

local template = wibox.widget {
    id = "background_role",
    widget  = wibox.container.background,
    {
        widget = wibox.container.margin,
        margins = 5,
        {
            widget = wibox.container.place,
            align = "center",
            valign = "center",
            {
                widget = wibox.widget.textbox,
                text = "+",
                font = "sans 15",
            }
        }
    },
}

function PlusButton.new(workspaceManagerService)
    local self = {}
    setmetatable(self, PlusButton)

    -- Debugger.dbg()

    self.tmpl = template

    local bg = __.first( self.tmpl:get_children_by_id('background_role') ) or nil

    if bg then
        bg:connect_signal("mouse::enter", function()
            bg.bg = beautiful.bg_focus
        end)
        bg:connect_signal("mouse::leave", function()
            bg.bg = beautiful.bg_normal
        end)
        bg:connect_signal("button::press", function()
            workspaceManagerService:addTagToWorkspace()
        end)
    end

    return self
end

-- view widget
function PlusButton:get_view_widget()
    return self.tmpl
end


return setmetatable(PlusButton, {
    __call = function(_, workspaceManagerService)
        return PlusButton.new(workspaceManagerService):get_view_widget()
    end
})