-- https://blingcorp.github.io/bling/#/module/wall
-- Default parameters
-- bling.module.wallpaper.setup {
--     screen = nil,       -- the screen to apply the wallpaper, as seen in gears.wallpaper functions
--     screens = nil,      -- an array of screens to apply the wallpaper on. If 'screen' is also provided, this is overridden
--     change_timer = nil, -- the timer in seconds. If set, call the set_function every change_timer seconds
--     set_function = nil, -- the setter function

--     -- parameters used by bling.module.wallpaper.prepare_list
--     wallpaper = nil,                               -- the wallpaper object, see simple or simple_schedule documentation
--     image_formats = {"jpg", "jpeg", "png", "bmp"}, -- when searching in folder, consider these files only
--     recursive = true,                              -- when searching in folder, search also in subfolders

--     -- parameters used by bling.module.wallpaper.apply
--     position = nil,                              -- use a function of gears.wallpaper when applicable ("centered", "fit", "maximized", "tiled")
--     background = beautiful.bg_normal or "black", -- see gears.wallpaper functions
--     ignore_aspect = false,                       -- see gears.wallpaper.maximized
--     offset = {x = 0, y = 0},                     -- see gears.wallpaper functions
--     scale = 1,                                   -- see gears.wallpaper.centered

--     -- parameters that only apply to bling.module.wallpaper.setter.awesome (as a setter or as a wallpaper function)
--     colors = {                   -- see beautiful.theme_assets.wallpaper
--         bg = beautiful.bg_color,  -- the actual default is this color but darkened or lightned
--         fg = beautiful.fg_color,
--         alt_fg = beautiful.fg_focus
--     }
-- }

local bling = require("sub/bling")
local beautiful = require("beautiful")

return setmetatable({}, {
    __constructor = function (settings)
        bling.module.wallpaper.setup {
            set_function = settings.wallpaper.set_function or bling.module.wallpaper.setters.simple,
            wallpaper = settings.wallpaper.wallpaper or beautiful.wallpaper,
            position = settings.wallpaper.position or "maximized",
            ignore_aspect = settings.wallpaper.ignore_aspect or true,
        }
    end
})