--[[ Settings flat file for Rabbithole

Returns a settings object to be used with the settingsManager service.

Theme table:
    These are the only colors that need to be set for a custom theme.
    The rest of the colors will be generated automatically. You can also
    use a single color and pick a color theory and tesseract will generate an
    Md3 and color theory compliant theme for you. Themes can also be generated
    from the background image or URL. We thought of everything.
]]

-- Create the Settings object so it's seen by the dependency injector
local Settings = { }
Settings.__index = Settings

function Settings.new()
    local self = setmetatable({}, Settings)

    self.settings = {
        -- General settings
        theme = {
            generate_theme = false,
            theme_name = "rabbithole", -- set to nil if you want to use the default theme

            "rabbithole",
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
        -- NOTE: The order of these icons should match the order of the tag names below
        -- If you don't want to use tag names, just set this to nil
        tag_names = {"Internet", "Code", "Terminal", "Files" -- add more tag names as needed...
        },
        global_tag_names = {"Brain2", "Chat" -- add more global tag names as needed...
        },
        tag_layouts = {"tile", "float" -- add more layout types as needed...
        },
        -- NOTE: The order of these icons should match the order of the tag names above
        -- If you don't want to use icons, just set this to nil

        tag_icons = {"path/to/icon.svg" -- add more icons as needed...
        },
        -- Autostart applications
        autostart_apps = {"picom &", "nm-applet &", "blueman-applet &", "xfce4-power-manager &", "flameshot &" -- add more autostart apps as needed...
        }
    }

    return self
end

return Settings
