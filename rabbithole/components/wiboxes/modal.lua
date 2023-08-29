local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- testing:
-- send <<< 'require("rabbithole.components.wiboxes.modal").new({})'

-- should be able to call setup() on this
-- TODO custom theme variable for shape of modal

local ModalFactory = {}
ModalFactory.__index = ModalFactory

function ModalFactory.new()

    return function (args)
        return awful.popup(gears.table.crush({
            minimum_width = 300,
            minimum_height = 100,
            placement = awful.placement.centered,
            visible = true,
            ontop = true,
            widget = wibox.widget.textbox(),
            screen = awful.screen.focused(),
        }, args or {}))
    end

end

return ModalFactory