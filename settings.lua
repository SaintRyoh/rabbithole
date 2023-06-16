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
    tetradic, clash, five_tone, six_tone, neutral, and custom.

    Default settinngs mimic the default theme.lua. Generated with tesseract.
    ]]
    theme = {
        -- [[[ Tesseract theme generation settings
        generate_theme = false, -- this will generate a theme using the tesseractThemeEngine when true
        color_scheme = "monochromatic", -- this is the color theory used to generate the theme
        -- ]]]
        theme_name = "rabbithole",
        theme_dir = "themes/rabbithole/theme.lua",
        wallpaper = "rabbithole/wallpapers/japan.jpg",
        -- [[[ Theme colors--These are the most important settings.
        base_color = colors["Blue"]["400"],
        secondary_color = colors["Periwinkle"]["500"],
        tertiary_1 = colors["Blue"]["700"],
        tertiary_2 = colors["Blue"]["600"],
        neutral = colors["Blue Grey"]["900"],
        -- ]]]
        -- [[[ Fonts
        font = "Ubuntu 8",
        fg_normal = colors["Black"],
        fg_focus = colors["Black"],
        fg_urgent = colors["Black"],
        -- ]]]
        -- The following should be left as defaults, but you can change if desired.
        --neutral = colors["Blue Grey"]["900"],
        --success = colors["Green"]["500"],
        --info = colors["Blue"]["500"],
        --warning = colors["Yellow"]["500"],
        --danger = colors["Red"]["500"],
    },
    default_programs = {
        -- Rabbithole's recommened programs. These are used in the keybindings.
        terminal = "qterminal" or "xterm",
        browser = "firefox",
        editor = os.getenv("EDITOR") or "nvim",
        editor_cmd = "qterminal -e nvim",
        file_manager = "nemo" or "pcmanfm-qt",
        music_player = "spotify" or "mpd",
        video_player = "mpv",
        screenshot_tool = "flameshot",
        launcher_cmd = "rofi",
        lock_screen = "i3lock-fancy",
        power_menu = "rofi-power-menu",
        volume_control = "pavucontrol",
        brightness_control = "brightnessctl",
    },
    core_settings = {
        wallpaper = "rabbithole/wallpapers/japan.jpg",
        modkey = "Mod4",
        altkey = "Mod1",
        icon_theme = "BeautyLine",
    },
    -- UI placement
    -- NOTE: NOT CONNECTED YET
    ui_placement = {
        activities_placement = "top-left",
        taglist_placement = "top-center",
        systray_placement = "top-right",
    },
    -- Rabbitholes Environment Settings - Order matters here. The first layout will be the default.
    -- NOTE: NOT CONNECTED YET
    tag_names = {"Internet", "Code", "Terminal", "Files"},
    global_tag_names = {"Brain2", "Chat"},
    workspace_names = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
    tag_layouts = {"tile", "float"},
    tag_icons = {"path/to/icon.svg"},
    autostart_apps = {"picom &", "nm-applet &", "blueman-applet &", "xfce4-power-manager &", "flameshot &"},
}
