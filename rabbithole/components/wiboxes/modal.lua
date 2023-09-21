local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- testing:
-- send <<< 'require("rabbithole.components.wiboxes.modal").new({})'

-- should be able to call setup() on this
-- TODO custom theme variable for shape of modal

local ModalFactory = {}
ModalFactory.__index = ModalFactory

function ModalFactory.new()

    return function (args)
        return ModalFactory.empty(args)
    end

end

function ModalFactory.empty(args)
    return ModalFactory.connect_widget_update_signal(
        ModalFactory.get_popup({ widget = args.widget, }),
        args.widget
    )
end

function ModalFactory.get_popup(args)
    return awful.popup({
        -- popup properties
        minimum_width = 10,
        minimum_height = 5,
        placement = awful.placement.centered,
        visible = true,
        ontop = true,
        screen = awful.screen.focused(),

        -- This centers the widget horizontally and vertically
        widget = wibox.widget {
            {
                args.widget or wibox.widget.textbox("No widget provided"),
                layout = wibox.container.place,
                valign = "center",
            },
            widget = wibox.container.margin,
            left = dpi(15),
            right = dpi(15),
            top = dpi(5),
            bottom = dpi(5),
        }
    })
end

function ModalFactory.connect_widget_update_signal(modal, widget)
    widget:connect_signal("widget::updated", function()
        local new_width = widget:get_preferred_size()
        modal.popup_widget.width = new_width.width
        modal.popup_widget.height = new_width.height
    end)
    return modal
end

return ModalFactory