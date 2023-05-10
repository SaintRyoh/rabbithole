local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local gears = require("gears")
--  custom local libs
local make3d = require("rabbithole.services.color").create_widget_bg
local colors = require("rabbithole.services.tesseractThemeEngine.colors")
-- Theme icons table
local icons = require("themes.rabbithole.theme-icons")
local table_utils = require("rabbithole.services.table-utils")
-- Theme shapes table
local shapes = require("themes.rabbithole.theme-shapes")

local theme = {}

-- Wallpaper 
theme.wallpaper = themes_path .. "rabbithole/wallpapers/whitelion.jpg"
-- Base font and font colors
theme.font = "Ubuntu 8"

theme.fg_normal = colors['White']
theme.fg_focus = colors['White']
theme.fg_urgent = colors['White']
-- Base color for the theme
theme.base_color = colors['Deep Purple']['500']
-- Background colors for widgets. This is the bulk of the color you see.
theme.bg_normal = make3d(theme.base_color, colors['Deep Purple']['400'])
theme.bg_focus = make3d(colors['Pink']['300'], colors['Pink']['400'])
--theme.bg_urgent = colors['Grey']['900']

theme.bg_systray = colors['Grey']['800']

theme.border_normal = theme.base_color
theme.border_focus = "#6e5bd6"
theme.border_marked = "#CC9393"

theme.titlebar_bg_focus = make3d(theme.base_color, "#6e5bd6")
theme.titlebar_bg_normal = make3d("#6e5bd6", theme.base_color)

theme.taglist_bg_normal = theme.bg_normal
theme.taglist_bg_empty = theme.taglist_bg_normal
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_fg_empty = theme.fg_focus
theme.taglist_container_bg = "#421500"

theme.tasklist_bg_normal = "#3F3F3F"
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_shape_border_color = theme.tasklist_bg_normal

theme.notification_bg = "#3F3F3F"
theme.notification_fg = "#FFFFFF"
theme.notification_border_color = "#3F3F3F"

-- [[[ BLING theme variables
theme.tag_preview_client_border_color = theme.base_color
theme.tag_preview_widget_border_color = "#3f3f3f"
-- ]]]

-- Merge tables
theme = table_utils.merge(theme, icons, theme_shapes)

return theme
