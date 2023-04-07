local awful = require("awful")
local gears = require("gears")
local TagView = require("src.widgets.taglist.tag_view")

local TagController = {}

function TagController:create_buttons(object)
    local buttons = gears.table.join(
        awful.button(
            {},
            1,
            function(t)
                t:view_only()
            end
        ),
        awful.button(
            { modkey },
            1,
            function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end
        ),
        awful.button(
            {},
            3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        awful.button(
            { modkey },
            3,
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),
        awful.button(
            {},
            4,
            function(t)
                awful.tag.viewnext(t.screen)
            end
        ),
        awful.button(
            {},
            5,
            function(t)
                awful.tag.viewprev(t.screen)
            end
        )
    )
    return buttons
end

function TagController:list_update(widget, objects)
    widget:reset()
    local buttons = self:create_buttons()

    for _, object in ipairs(objects) do
        local tag_widget = TagView:create_tag_widget(object, buttons)
        TagView:update_tag_widget(tag_widget, object)
        TagView:setup_hover_signals(tag_widget, object)
        widget:add(tag_widget)
        widget:set_spacing(dpi(6))
    end
end

return TagController
