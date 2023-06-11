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
    wallpaper = "japan.jpg",
    default_font = "Ubuntu 8",
    default_icon_theme = "BeautyLine",

    -- AwesomeWM specific settings
    modkey = "Mod4",
    altkey = "Mod1",
    activities_menu_placement = "top",
    -- NOTE: The order of these icons should match the order of the tag names below
    -- If you don't want to use tag names, just set this to nil
    tag_names = {
        "Internet",
        "Code",
        "Terminal",
        "Files",
        -- add more tag names as needed...
    },
    global_tag_names = {
        "Chat",
        "2Brain",
        -- add more global tag names as needed...
    },
    tag_layouts = {
        "tile",
        "float",
        -- add more layout types as needed...
    },
    -- NOTE: The order of these icons should match the order of the tag names above
    -- If you don't want to use icons, just set this to nil

    tag_icons = {
        "path/to/icon.svg",
        -- add more icons as needed...
    },
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