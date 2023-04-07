local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local color = require("src.themes.rabbithole.colors")
require("src.tools.icon_handler")

local TagView = {}

function TagView:create_tag_widget(object, buttons)
    local tag_widget = wibox.widget {
        {
            {
                {
                    text = "",
                    align = "center",
                    valign = "center",
                    visible = true,
                    font = user_vars.font.extrabold,
                    forced_width = dpi(25),
                    id = "label",
                    widget = wibox.widget.textbox
                },
                id = "margin",
                left = dpi(5),
                right = dpi(5),
                widget = wibox.container.margin
            },
            id = "container",
            layout = wibox.layout.fixed.horizontal
        },
        fg = color["White"],
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 5)
        end,
        widget = wibox.container.background
    }

    tag_widget:buttons(buttons)
    return tag_widget
end

function TagView:update_tag_widget(tag_widget, object)
    local label_widget = tag_widget.container.margin.label
    label_widget:set_text(object.index)

    if object.urgent == true then
        tag_widget:set_bg(color["RedA200"])
        tag_widget:set_fg(color["Grey900"])
    elseif object == awful.screen.focused().selected_tag then
        tag_widget:set_bg(color["White"])
        tag_widget:set_fg(color["Grey900"])
    else
        tag_widget:set_bg("#3A475C")
    end

    for _, client in ipairs(object:clients()) do
        tag_widget.container.margin:set_right(0)
        local icon = wibox.widget {
            {
                id = "icon_container",
                {
                    id = "icon",
                    resize = true,
                    widget = wibox.widget.imagebox
                },
                widget = wibox.container.place
            },
            forced_width = dpi(33),
            margins = dpi(6),
            widget = wibox.container.margin
        }
        icon.icon_container.icon:set_image(Get_icon(user_vars.icon_theme, client))
        tag_widget.container:setup({
            icon,
            strategy = "exact",
            layout = wibox.container.constraint,
        })
    end
end

function TagView:setup_hover_signals(tag_widget, object)
    local old_wibox, old_cursor, old_bg
    tag_widget:connect_signal(
        "mouse::enter",
        function()
            old_bg = tag_widget.bg
            if object == awful.screen.focused().selected_tag then
                tag_widget.bg = '#dddddd' .. 'dd'
            else
                tag_widget.bg = '#3A475C' .. 'dd'
            end
            local w = mouse.current_wibox
            if w then
                old_cursor, old_wibox = w.cursor, w
                w.cursor = "hand1"
            end
        end
    )

    tag_widget:connect_signal(
        "button::press",
        function()
            if object == awful.screen.focused().selected_tag then
                tag_widget.bg = '#bbbbbb' .. 'dd'
            else
                tag_widget.bg = '#3A475C' .. 'dd'
            end
        end
    )

    tag_widget:connect_signal(
        "button::release",
        function()
            if object == awful.screen.focused().selected_tag then
                tag_widget.bg = '#dddddd' .. 'dd'
            else
                tag_widget.bg = '#3A475C' .. 'dd'
            end
        end
    )

    tag_widget:connect_signal(
        "mouse::leave",
        function()
            tag_widget.bg = old_bg
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end
    )
end

return TagView
