local wibox = require("wibox")
local beautiful = require("beautiful")
local __ = require("lodash")
local gears = require("gears")
local color = require("rabbithole.services.color")


local PlusButton = {}
PlusButton.__index = PlusButton

local template = wibox.widget {
    id = "background_role",
    widget  = wibox.container.background,
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
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
            bg.bg = color:smartGradient(beautiful.tertiary_1, beautiful.tertiary_2, template.height, template.width)
        end)
        bg:connect_signal("mouse::leave", function()
            bg.bg = color:smartGradient(beautiful.base_color, beautiful.secondary_color, template.height, template.width)
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