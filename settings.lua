--[[ Settings flat file for Rabbithole

Returns a settings object to be used with the settingsManager service.
]]

return {
    -- General settings
    theme = "rabbithole",
    terminal = "qterminal",
    browser = "firefox",
    editor = "nvim",
    file_manager = "thunar",
    music_player = "spotify",
    video_player = "mpv",
    screenshot_tool = "flameshot",
    launcher = "rofi",
    lock_screen = "i3lock-fancy",
    power_menu = "rofi-power-menu",
    volume_control = "pavucontrol",
    brightness_control = "brightnessctl",
    default_wallpaper = "/usr/share/backgrounds/wallpaper.jpg",
    default_font = "Ubuntu 10",
    default_icon_theme = "BeautyLine",

    -- AwesomeWM specific settings
    modkey = "Mod4",
    altkey = "Mod1",
    activities_menu_placement = "top",
    tag_names = {
        "www",
        "dev",
        "sys",
        "doc",
        "vbox",
        -- add more tag names as needed...
    },
    tag_layouts = {
        "tile",
        "float",
        -- add more layout types as needed...
    },
    tag_icons = {
        "",
        "",
        "",
        "",
        "",
        -- add more icons as needed...
    },
    default_layout = "tile",
    default_layout_spacing = 5,
    default_layout_margins = { dpi(10), dpi(10), dpi(10), dpi(10) },
    default_layout_border_width = 0,
    default_layout_border_color = "#000000",
    default_layout_gaps = 5,
    default_layout_master_width_factor = 0.6,
    default_layout_master_fill_policy = "master_width_factor",
    default_layout_useless_gap = 5,
    default_layout_force_focus = true,
    default_layout_honor_padding = true,
    default_layout_honor_workarea = true,
    default_layout_maximized = false,
    default_layout_maximized_horizontal = false,
    default_layout_maximized_vertical = false,
    default_layout_fair = false,
    default_layout_fair_nmaster = 3,
    default_layout_fair_nmaster_ratio = 0.6,
    default_layout_spiral = false,
    default_layout_spiral_count = 4,
    default_layout_spiral_factor = 0.6,
    default_layout_dwindle = false,
    default_layout_dwindle_factor = 0.6,
    default_layout_centerworkarea = false,
    default_layout_magnifier = false,
    default_layout_magnifier_scale = 1.5,
    default_layout_magnifier_enabled = true,
    default_layout_magnifier_exclude_borders = true,
    default_layout_useless_resize = true,
    default_layout_useless_snapping = true,
    default_layout_useless_gap_resize = true,
    default_layout_useless_gap_snap = true,
    default_layout_useless_gap = 5,

    -- Autostart applications
    autostart_apps = {
        "picom &",
        "nm-applet &",
        "blueman-applet &",
        "redshift-gtk &",
        "xfce4-power-manager &",
        "udiskie &",
        "dunst &",
        "flameshot &",
        -- add more autostart apps as needed...
    },
}