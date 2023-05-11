local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"

local icons = {}

icons.awesome_icon = themes_path .. "rabbithole/awesome-icon.png"
--icons.menu_submenu_icon = themes_path .. "default/submenu.png -- we no longer have an icon for this. idk if we need to"

icons.layout_tile = themes_path .. "rabbithole/layouts/tile.svg"
icons.layout_tileleft = themes_path .. "rabbithole/layouts/tileleft.png"
icons.layout_tilebottom = themes_path .. "rabbithole/layouts/tilebottom.png"
icons.layout_tiletop = themes_path .. "rabbithole/layouts/tiletop.png"
icons.layout_fairv = themes_path .. "rabbithole/layouts/fairv.png"
icons.layout_fairh = themes_path .. "rabbithole/layouts/fairh.png"
icons.layout_spiral = themes_path .. "rabbithole/layouts/spiral.png"
icons.layout_dwindle = themes_path .. "rabbithole/layouts/dwindle.png"
icons.layout_max = themes_path .. "rabbithole/layouts/max.png"
icons.layout_fullscreen = themes_path .. "rabbithole/layouts/fullscreen.png"
icons.layout_magnifier = themes_path .. "rabbithole/layouts/magnifier.png"
icons.layout_floating = themes_path .. "rabbithole/layouts/floating.png"
icons.layout_cornernw = themes_path .. "rabbithole/layouts/cornernw.png"
icons.layout_cornerne = themes_path .. "rabbithole/layouts/cornerne.png"
icons.layout_cornersw = themes_path .. "rabbithole/layouts/cornersw.png"
icons.layout_cornerse = themes_path .. "rabbithole/layouts/cornerse.png"

icons.titlebar_close_button_focus = themes_path .. "rabbithole/titlebar/close_focus.png"
icons.titlebar_close_button_normal = themes_path .. "rabbithole/titlebar/close_normal.png"
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

icons.titlebar_maximized_button_focus_active = themes_path .. "rabbithole/titlebar/maximized_focus_active.png"
icons.titlebar_maximized_button_normal_active = themes_path .. "rabbithole/titlebar/maximized_normal_active.png"
icons.titlebar_maximized_button_focus_inactive = themes_path .. "rabbithole/titlebar/maximized_focus_inactive.png"
icons.titlebar_maximized_button_normal_inactive = themes_path .. "rabbithole/titlebar/maximized_normal_inactive.png"

return icons
