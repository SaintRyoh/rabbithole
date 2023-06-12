local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local true3d = require("rabbithole.services.color").twoColorTrue3d
local colors = require("rabbithole.services.tesseractThemeEngine.colors")
-- Theme resources
local icons = require("themes.rabbithole.theme-icons")
local table_utils = require("rabbithole.services.table-utils")
local shapes = require("themes.rabbithole.theme-shapes")
local add_redundancies = require("themes.rabbithole.theme-redundant")

local theme = {}

-- Wallpaper 
theme.wallpaper = themes_path .. "rabbithole/wallpapers/japan.jpg"
-- Base font and font colors
theme.font = "Ubuntu 8"

-- White and black are always needed.
theme.white = colors['White']
theme.black = colors['Black']

-- TODO: Add font color calculator for tesseract and plug that in here.
theme.fg_normal = theme.black -- font colors
theme.fg_focus = theme.black
theme.fg_urgent = theme.black

-- The bulk of the theme boils down to these lines
theme.base_color = colors['Blue']['400'] -- ~ 60% of theme color
theme.secondary_color = colors['Periwinkle']['500'] -- ~ 30% of theme color. This can be a monochromatic color or a color theory scheme for interesting gradients
theme.tertiary_1 = colors['Blue']['700'] -- ~ 10% of theme color
theme.tertiary_2 = colors['Blue']['600'] -- ~ 10% of theme color
theme.neutral = colors['Blue Grey']['900'] --  neutral color for widgets

-- Errors, info, and CTAs (calls to action) variables
theme.success = colors['Green']['500']
theme.info = colors['Blue']['500']
theme.warning = colors['Yellow']['500']
theme.danger = colors['Red']['500']

-- Background colors for widgets. This is the bulk of the color you see.
theme.bg_normal = true3d(theme.base_color, theme.secondary_color)
theme.bg_focus = true3d(theme.tertiary_1, theme.tertiary_2)
theme.bg_urgent = theme.info
theme.bg_systray = theme.neutral 

theme.border_normal = theme.base_color
theme.border_focus = theme.secondary_color
theme.border_marked = theme.danger

-- [[[ Titlebar variables
-- Re-enable if for whatever reason we get rid of the 'nice' submodule in the future.
--theme.titlebar_bg_focus = true3d(theme.base_color, theme.secondary_color)
--theme.titlebar_bg_normal = true3d(theme.secondary_color, theme.base_color)
-- ]]]

-- Merge tables
theme = table_utils.merge(theme, icons, shapes)
add_redundancies(theme)


return theme
