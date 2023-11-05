local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- testing:
-- send <<< 'require("rabbithole.components.wiboxes.overlay").new({})'

local OverlayFactory = {}
OverlayFactory.__index = OverlayFactory

function OverlayFactory.new()

    return function (args)
        return awful.popup(gears.table.crush({
            minimum_width = awful.screen.focused().geometry.width,
            minimum_height = awful.screen.focused().geometry.height,
            placement = awful.placement.top_left,
            visible = true,
            ontop = true,
            widget = wibox.widget.textbox(),
            screen = awful.screen.focused(),
        }, args or {}))
    end

end

return OverlayFactory