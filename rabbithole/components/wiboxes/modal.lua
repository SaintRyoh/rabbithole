local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local modal_width
local modal_height
-- rounded corners
-- local 

local Modal = {}
Modal.__index = Modal

function Modal.new(args)

    -- args.width = args.width or 300
    -- args.height = args.height or 100

    -- -- If no position is specified, center the widget on the screen
    -- if not args.x and not args.y then
    --     local screen = awful.screen.focused()
    --     local geometry = screen.geometry
    --     args.x = (geometry.width - args.width) / 2
    --     args.y = (geometry.height - args.height) / 2
    -- end

    local default_args = gears.table.crush({
        minimum_width = 300,
        minimum_height = 100,
        placement = awful.placement.centered,
        visible = true,
        ontop = true,
        widget = wibox.widget.textbox(),
        screen = awful.screen.focused(),
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        border_width = beautiful.border_width or 3,
        border_color = beautiful.border_color or beautiful.danger,
        

    }, args or {})

    -- If no position is specified, center the widget on the screen
    -- if not default_args.x and not default_args.y then
    --     local screen = awful.screen.focused()
    --     local geometry = screen.geometry
    --     default_args.x = (geometry.width - default_args.width) / 2
    --     default_args.y = (geometry.height - default_args.height) / 2
    -- end

    -- If fullscreen is specified, cover the entire screen
    -- if default_args.fullscreen then
    --     default_args.x = 0
    --     default_args.y = 0
    --     default_args.width = awful.screen.focused().geometry.width
    --     default_args.height = awful.screen.focused().geometry.height
    -- end

    local popup = awful.popup(default_args)

    -- Update the popup_widget size when the child widget changes
    popup.widget:connect_signal("widget::updated", function()
        local new_width = popup.widget:get_preferred_size()
        popup.width = new_width.width
        popup.height = new_width.height
    end)

    return popup
end

return Modal