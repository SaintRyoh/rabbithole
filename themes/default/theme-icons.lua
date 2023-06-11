local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local colors = require("rabbithole.services.tesseractThemeEngine.colors")
local recolor = require("gears.color").recolor_image

local icons = {}

icons.rabbit_icon = themes_path .. "rabbithole/icons/rabbit-menu.svg"
--icons.menu_submenu_icon = themes_path .. "default/submenu.png -- we no longer have an icon for this. idk if we need to"

-- [[[ Layouts
icons.layout_tile = themes_path .. "rabbithole/layouts/tile.svg"
icons.layout_tileleft = themes_path .. "rabbithole/layouts/tileleft.png"
icons.layout_tilebottom = themes_path .. "rabbithole/layouts/tilebottom.png"
icons.layout_tiletop = themes_path .. "rabbithole/layouts/tiletop.png"
icons.layout_fairv = themes_path .. "rabbithole/layouts/fairv.png"
icons.layout_fairh = themes_path .. "rabbithole/layouts/fairh.png"
icons.layout_spiral = themes_path .. "rabbithole/layouts/spiral.png"
icons.layout_dwindle = themes_path .. "rabbithole/layouts/dwindle.svg"
icons.layout_max = themes_path .. "rabbithole/layouts/max.png"
icons.layout_fullscreen = themes_path .. "rabbithole/layouts/fullscreen.png"
icons.layout_magnifier = themes_path .. "rabbithole/layouts/magnifier.svg"
icons.layout_floating = themes_path .. "rabbithole/layouts/floating.svg"
icons.layout_cornernw = themes_path .. "rabbithole/layouts/cornernw.png"
icons.layout_cornerne = themes_path .. "rabbithole/layouts/cornerne.png"
icons.layout_cornersw = themes_path .. "rabbithole/layouts/cornersw.png"
icons.layout_cornerse = themes_path .. "rabbithole/layouts/cornerse.png"
-- ]]]
icons.titlebar_close_button_focus = themes_path .. "rabbithole/titlebar/close_focus.svg"
icons.titlebar_close_button_normal = recolor(themes_path .. "rabbithole/titlebar/close_normal.png", colors["Grey"][500])
icons.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
icons.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

icons.titlebar_ontop_button_focus_active = themes_path .. "rabbithole/titlebar/ontop_focus_active.png"
icons.titlebar_ontop_button_normal_active = themes_path .. "rabbithole/titlebar/ontop_normal_active.png"
icons.titlebar_ontop_button_focus_inactive = themes_path .. "rabbithole/titlebar/ontop_focus_inactive.png"
icons.titlebar_ontop_button_normal_inactive = themes_path .. "rabbithole/titlebar/ontop_normal_inactive.png"

icons.titlebar_sticky_button_focus_active = themes_path .. "rabbithole/titlebar/sticky_focus_active.png"
icons.titlebar_sticky_button_normal_active = themes_path .. "rabbithole/titlebar/sticky_normal_active.png"
icons.titlebar_sticky_button_focus_inactive = themes_path .. "rabbithole/titlebar/sticky_focus_inactive.png"
icons.titlebar_sticky_button_normal_inactive = themes_path .. "rabbithole/titlebar/sticky_normal_inactive.png"

icons.titlebar_floating_button_focus_active = themes_path .. "rabbithole/titlebar/floating_focus_active.png"
icons.titlebar_floating_button_normal_active = themes_path .. "rabbithole/titlebar/floating_normal_active.png"
icons.titlebar_floating_button_focus_inactive = themes_path .. "rabbithole/titlebar/floating_focus_inactive.png"
icons.titlebar_floating_button_normal_inactive = themes_path .. "rabbithole/titlebar/floating_normal_inactive.png"

icons.titlebar_maximized_button_focus_active = themes_path .. "rabbithole/titlebar/maximize_focus.png"
icons.titlebar_maximized_button_normal_active = recolor(themes_path .. "rabbithole/titlebar/maximize_focus.png", colors["Grey"][500])
icons.titlebar_maximized_button_focus_inactive = themes_path .. "rabbithole/titlebar/maximize_focus.png"
icons.titlebar_maximized_button_normal_inactive = recolor(themes_path .. "rabbithole/titlebar/maximize_focus.png", colors["Grey"][500])

return icons
