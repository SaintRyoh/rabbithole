local bling = require("sub/bling")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local TagPreview = {}
TagPreview.__index = TagPreview

local visible = false

function TagPreview.new()
    local self = setmetatable({}, TagPreview)
    bling.widget.tag_preview.enable {
        show_client_content = true,  -- Whether or not to show the client content
        scale = 0.25,  -- The scale of the previews compared to the screen
        placement_fn = function(obj)    -- Place the widget using awful.placement (this overrides x & y)
            local mouse_coords = mouse.coords()
            obj.x = mouse_coords.x - obj.width / 2
            obj.y = mouse_coords.y + dpi(15) -- Move the object 20 pixels below the cursor
            return obj
        end,
        background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
            image = beautiful.wallpaper,
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
            widget = wibox.widget.imagebox
        }
    }
    return self
end

function TagPreview:show(tag, screen)
    -- BLING: Only show widget when there are clients in the tag
    if #tag:clients() > 0 and not visible then
        -- BLING: Update the widget with the new tag
        awesome.emit_signal("bling::tag_preview::update", tag)
        -- BLING: Show the widget
        awesome.emit_signal("bling::tag_preview::visibility", screen, true)
        visible = true
    end
end

function TagPreview:hide(screen)
    -- BLING: Turn the widget off
    if visible then
        awesome.emit_signal("bling::tag_preview::visibility", screen, false)
        visible = false
    end
end

return setmetatable(TagPreview, {
    __call = TagPreview.new,
})
