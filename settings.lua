--[[ Settings flat file for Rabbithole

Returns a settings object to be used with the settingsManager service.

Theme table:
    These are the only colors that need to be set for a custom theme.
    The rest of the colors will be generated automatically. You can also
    use a single color and pick a color theory and tesseract will generate an
    Md3 and color theory compliant theme for you. Themes can also be generated
    from the background image or URL. We thought of everything.
]]
local colors = require("rabbithole.services.tesseractThemeEngine.colors")

return {
    --[[ For color_scheme, you can use any of the color schemes listed here:
    polychromatic, monochromatic, analogous, complementary, split_complementary, triadic, 
    tetradic, clash, five_tone, six_tone, neutral, and custom
    ]]
    theme = {
        generate_theme = true, -- this will generate a theme using the tesseractThemeEngine
        theme_name = "rabbithole",
        wallpaper = "rabbithole/wallpapers/japan.jpg",
        font = "Ubuntu 8",
        white = colors["White"],
        black = colors["Black"],
        fg_normal = colors["Black"],
        fg_focus = colors["Black"],
        fg_urgent = colors["Black"],
        base_color = colors["Blue"]["400"],
        secondary_color = colors["Periwinkle"]["500"],
        tertiary_1 = colors["Blue"]["700"],
        tertiary_2 = colors["Blue"]["600"],
        neutral = colors["Blue Grey"]["900"],
        success = colors["Green"]["500"],
        info = colors["Blue"]["500"],
        warning = colors["Yellow"]["500"],
        danger = colors["Red"]["500"],
        -- Adjusted these settings to use colors from colors module
        bg_normal = colors["Blue"]["400"] .. "," .. colors["Periwinkle"]["500"],
        bg_focus = colors["Blue"]["700"] .. "," .. colors["Blue"]["600"],
        icons = "themes.rabbithole.theme-icons",
        shapes = "themes.rabbithole.theme-shapes",
    },
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
    tag_names = {"Internet", "Code", "Terminal", "Files"},
    global_tag_names = {"Brain2", "Chat"},
    tag_layouts = {"tile", "float"},
    tag_icons = {"path/to/icon.svg"},
    autostart_apps = {"picom &", "nm-applet &", "blueman-applet &", "xfce4-power-manager &", "flameshot &"},
}
