local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local theme_shapes = {}

theme_shapes.useless_gap = dpi(3)
theme_shapes.border_width = dpi(2)
theme_shapes.taglist_spacing = 1
theme_shapes.menu_height = dpi(15)
theme_shapes.menu_width = dpi(100)
theme_shapes.taglist_shape = gears.shape.rounded_rect
theme_shapes.tasklist_shape = gears.shape.rounded_rect
theme_shapes.tasklist_shape_border_width = dpi(1)
theme_shapes.notification_border_width = dpi(1)
theme_shapes.notification_shape = gears.shape.rounded_rect
theme_shapes.notification_margin = dpi(10)
theme_shapes.notification_icon_size = dpi(80)
theme_shapes.notification_max_width = dpi(600)
theme_shapes.notification_max_height = dpi(400)

return theme_shapes
