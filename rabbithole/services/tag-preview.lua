local bling = require("sub.bling")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local TagPreview = {}
TagPreview.__index = TagPreview

local visible = false

function TagPreview.new()
    local self = setmetatable({}, TagPreview)

    bling.widget.tag_preview.enable {
        show_client_content = true,
        scale = 0.25,
        placement_fn = function(obj)
            local mouse_coords = mouse.coords()
            obj.x = mouse_coords.x - obj.width / 2
            obj.y = mouse_coords.y + dpi(15)
            return obj
        end,
        background_widget = wibox.widget {
            image = beautiful.wallpaper,
            horizontal_fit_policy = "fit",
            vertical_fit_policy = "fit",
            widget = wibox.widget.imagebox
        }
    }

    return self
end

function TagPreview:show(tag, screen)
    if #tag:clients() > 0 and not visible then
        awesome.emit_signal("bling::tag_preview::update", tag)
        awesome.emit_signal("bling::tag_preview::visibility", screen, true)
        visible = true
    end
end

function TagPreview:hide(screen)
    if visible then
        awesome.emit_signal("bling::tag_preview::visibility", screen, false)
        visible = false
    end
end

return TagPreview
