local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local create_widget_bg = function(color1, color2)
    return {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(40) },
        stops = {
            { 0,   color1 },
            { 0.5, color2 },
            { 1,   color1 }
        }
    }
end

local create_widget_shadow = function(radius, offset)
    return {
        offset = offset,
        color = "#000000",
        opacity = 1.4,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, radius)
        end
    }
end

-- Helper function to darken a color
local function darken_color(hex_color, percent)
    local r, g, b = gears.color.parse_color(hex_color)
    r = math.max(math.min(255, r * (1 - percent)), 0)
    g = math.max(math.min(255, g * (1 - percent)), 0)
    b = math.max(math.min(255, b * (1 - percent)), 0)
    return string.format("#%02x%02x%02x", r, g, b)
end

local theme = {}
theme.wallpaper = themes_path .. "rabbithole/purple.jpg"

theme.font = "Ubuntu 8"

theme.fg_normal = "#FFFFFF"
theme.fg_focus = "#FFFFFF"
theme.fg_urgent = "#FFFFFF"

theme.base_color = "#5123db"
theme.bg_normal = create_widget_bg(theme.base_color, "#6e5bd6")
theme.bg_focus = create_widget_bg("#6e5bd6", theme.base_color)
theme.bg_urgent = "#3F3F3F"
theme.bg_systray = "#000000"

theme.useless_gap = dpi(3)
theme.border_width = dpi(2)
theme.border_normal = theme.base_color
theme.border_focus = "#6e5bd6"
theme.border_marked = "#CC9393"

theme.titlebar_bg_focus = create_widget_bg(theme.base_color, "#6e5bd6")
theme.titlebar_bg_normal = create_widget_bg("#6e5bd6", theme.base_color)

theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.taglist_shape = gears.shape.rounded_rect
theme.taglist_bg_normal = theme.bg_normal
theme.taglist_bg_empty = theme.taglist_bg_normal
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_squares_sel = themes_path .. "zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "zenburn/taglist/squarez.png"

theme.awesome_icon = themes_path .. "zenburn/awesome-icon.png"
theme.menu_submenu_icon = themes_path .. "default/submenu.png"

theme.layout_tile = themes_path .. "zenburn/layouts/tile.png"
theme.layout_tileleft = themes_path .. "zenburn/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "zenburn/layouts/tilebottom.png"
theme.layout_tiletop = themes_path .. "zenburn/layouts/tiletop.png"
theme.layout_fairv = themes_path .. "zenburn/layouts/fairv.png"
theme.layout_fairh = themes_path .. "zenburn/layouts/fairh.png"
theme.layout_spiral = themes_path .. "zenburn/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "zenburn/layouts/dwindle.png"
theme.layout_max = themes_path .. "zenburn/layouts/max.png"
theme.layout_fullscreen = themes_path .. "zenburn/layouts/fullscreen.png"
theme.layout_magnifier = themes_path .. "zenburn/layouts/magnifier.png"
theme.layout_floating = themes_path .. "zenburn/layouts/floating.png"
theme.layout_cornernw = themes_path .. "zenburn/layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "zenburn/layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "zenburn/layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "zenburn/layouts/cornerse.png"

theme.titlebar_close_button_focus = themes_path .. "zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "zenburn/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active = themes_path .. "zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active = themes_path .. "zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active = themes_path .. "zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active = themes_path .. "zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "zenburn/titlebar/maximized_normal_inactive.png"

-- Set window corner rounding to 5px
client.connect_signal("property::size", function(c)
    gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 10)
end)
client.connect_signal("property::position", function(c)
    gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 10)
end)
-- Round client window borders
local function apply_rounded_corners(c)
    if c.round_corners then
        return
    end

    c.shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 5)
    end

    c.round_corners = true
end

client.connect_signal("manage", function(c)
    apply_rounded_corners(c)
end)

return theme
