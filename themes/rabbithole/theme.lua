local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local gears = require("gears")
--  custom local libs
local make3d = require("rabbithole.services.color").create_widget_bg
local test3d = require("rabbithole.services.color").create_widget_bg_3d
local colors = require("rabbithole.services.tesseractThemeEngine.colors")
-- Theme icons table
local icons = require("themes.rabbithole.theme-icons")
local table_utils = require("rabbithole.services.table-utils")
local shapes = require("themes.rabbithole.theme-shapes")

local theme = {}

-- Wallpaper 
theme.wallpaper = themes_path .. "rabbithole/wallpapers/japan.jpg"
-- Base font and font colors
theme.font = "Ubuntu 8"

theme.fg_normal = colors['Black'] -- font colors
theme.fg_focus = colors['Black']
theme.fg_urgent = colors['Black']

-- The bulk of the theme boils down to these lines
theme.base_color = colors['Blue']['200'] -- ~ 60% of theme color
theme.secondary_color = colors['Periwinkle']['500'] -- ~ 30% of theme color. This can be a monochromatic color or a color theory scheme for interesting gradients
theme.tertiary_1 = colors['Blue']['400'] -- ~ 10% of theme color
theme.tertiary_2 = colors['Blue']['300'] -- ~ 10% of theme color
theme.neutral = colors['Blue Grey']['900'] --  neutral color for widgets

-- Errors, info, and CTAs (calls to action) variables
theme.success = colors['Green']['500']
theme.info = colors['Blue']['500']
theme.warning = colors['Yellow']['500']
theme.danger = colors['Red']['500']

-- Background colors for widgets. This is the bulk of the color you see.
theme.bg_normal = test3d(theme.base_color)
theme.bg_focus = make3d(theme.tertiary_1, theme.tertiary_2)
theme.bg_urgent = theme.info
theme.bg_systray = theme.neutral 

theme.border_normal = theme.base_color
theme.border_focus = theme.secondary_color
theme.border_marked = theme.danger

-- [[[ Titlebar variables
theme.titlebar_bg_focus = make3d(theme.base_color, theme.secondary_color)
theme.titlebar_bg_normal = make3d(theme.secondary_color, theme.base_color)
-- ]]]

-- [[[ Taglist variables
theme.taglist_bg_normal = theme.bg_normal
theme.taglist_bg_empty = theme.taglist_bg_normal
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_fg_empty = theme.fg_focus
theme.taglist_container_bg = theme.bg_normal
-- ]]]

-- [[[ Tasklist variables
theme.tasklist_bg_normal = theme.neutral
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_shape_border_color = theme.tasklist_bg_normal
theme.tasklist_shape_border_color_minimized = theme.taglist_bg_neutral
-- ]]]
theme.notification_bg = theme.neutral
theme.notification_fg = colors['White']
theme.notification_border_color = theme.base_color

-- [[[ BLING theme variables
theme.tag_preview_client_border_color = theme.base_color
theme.tag_preview_widget_border_color = theme.neutral
-- ]]]

-- Merge tables
theme = table_utils.merge(theme, icons, shapes)

return theme
