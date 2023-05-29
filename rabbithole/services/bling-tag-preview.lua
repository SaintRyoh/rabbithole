local bling = require("sub/bling")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

return setmetatable({}, {
    __constructor = function ()
        bling.widget.tag_preview.enable {
            show_client_content = true,  -- Whether or not to show the client content
            -- x = 10,                       -- The x-coord of the popup
            -- y = 10,                       -- The y-coord of the popup
            scale = 0.25,                 -- The scale of the previews compared to the screen
            -- honor_padding = false,        -- Honor padding when creating widget size
            -- honor_workarea = false,       -- Honor work area when creating widget size
            placement_fn = function(obj)    -- Place the widget using awful.placement (this overrides x & y)
                local mouse_coords = mouse.coords()
                obj.x = mouse_coords.x - obj.width / 2
                obj.y = mouse_coords.y + dpi( 15 ) -- Move the object 20 pixels below the cursor
                return obj
            end,
            -- placement_fn = awful.placement.under_mouse,

            background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
                image = beautiful.wallpaper,
                horizontal_fit_policy = "fit",
                vertical_fit_policy   = "fit",
                widget = wibox.widget.imagebox
            }
        }
    end
})