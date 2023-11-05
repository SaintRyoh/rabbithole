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
local config_dir = require("gears.filesystem").get_configuration_dir()

return {
    --[[ For color_scheme, you can use any of the color schemes listed here:
    polychromatic, monochromatic, analogous, complementary, split_complementary, triadic,
    tetradic, TODO: clash, five_tone, six_tone, neutral, and custom.

    Default settinngs mimic the default theme.lua. Generated with tesseract.
    ]]
    theme = {
        -- [[[ Tesseract theme generation settings
        use_default = false,            -- toggling uses the default template only
        generate_theme = false,         -- this will generate a theme using the tesseractThemeEngine when true
        color_scheme = "monochromatic", -- this is the color theory used to generate the theme
        -- ]]]
        theme_name = "rabbithole",      -- TODO: used later for logic in saving themes
        theme_template = "/themes/rabbithole/theme.lua",
        wallpaper = config_dir .. "/themes/rabbithole/wallpapers/cozy-room.jpg",
        -- [[[ Theme colors--These are the most important settings.
        base_color = colors["Blue"]["400"], -- If you're generating a theme, you only need to pass a base_color
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
        terminal = os.getenv("TERMINAL") or "qterminal",
        browser = os.getenv("BROWSER") or "google-chrome-stable",
        editor = "featherpad",
        file_manager = "pcmanfm-qt",
        screenshot_tool = "lximage-qt --screenshot",
        launcher_cmd = "lxqt-runner",
        lock_screen = "lxqt-leave",
        volume_up = "pactl set-sink-volume @DEFAULT_SINK@ +5%",
        volume_down = "pactl set-sink-volume @DEFAULT_SINK@ -5%",
        volume_mute_toggle = "pactl set-sink-mute @DEFAULT_SINK@ toggle",
        mic_mute_toggle = "pactl set-source-mute @DEFAULT_SOURCE@ toggle",
        brightness_up = "brightnessctl set +10%",
        brightness_down = "brightnessctl set 10%-",
        screen_config = "lxqt-config-monitor",
        wifi_radio_toggle = [[
            if [ $(nmcli radio wifi) = 'enabled' ]; then
                nmcli radio wifi off
            else
                nmcli radio wifi on
            fi
        ]]
    },
    keys = {
        modkey = "Mod4",
        altkey = "Mod1",
    },
}
