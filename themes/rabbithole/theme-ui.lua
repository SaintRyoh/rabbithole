local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local theme_ui = {}

-- Window frame UI
theme_ui.useless_gap = dpi(2)
theme_ui.border_width = dpi(3)
-- Standard menu options
theme_ui.menu_height = dpi(15)
theme_ui.menu_width = dpi(120)
theme_ui.menu_shape = gears.shape.rounded_rect
-- Workspace menu
theme_ui.ws_menu_height = dpi(34)
theme_ui.ws_menu_width = dpi(120)
-- Tag options
theme_ui.taglist_shape = gears.shape.rounded_rect
theme_ui.taglist_spacing = 1

-- Tasklist options
theme_ui.tasklist_shape = gears.shape.rounded_rect
theme_ui.tasklist_shape_border_width = dpi(1)
theme_ui.tasklist_shape_border_width_minimized = dpi(6) -- DO NOT CHANGE
-- Notifications
theme_ui.notification_border_width = dpi(1)
theme_ui.notification_shape = gears.shape.rounded_rect
theme_ui.notification_margin = dpi(10)
theme_ui.notification_icon_size = dpi(80)
theme_ui.notification_max_width = dpi(600)
theme_ui.notification_max_height = dpi(400)

return theme_ui
