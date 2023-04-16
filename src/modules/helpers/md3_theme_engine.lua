local gears = require("gears")
local beautiful = require("beautiful")

local function create_advanced_theme(args)
    args = args or {}
    local theme = {}

    -- General settings
    theme.font = args.font or "Roboto 12"
    theme.primary = args.primary or "#6200EE"
    theme.secondary = args.secondary or "#03DAC6"
    theme.background = args.background or "#121212"
    theme.text = args.text or "#FFFFFF"

    -- Colors
    theme.bg_normal = args.bg_normal or theme.background
    theme.bg_focus = args.bg_focus or theme.primary
    theme.bg_urgent = args.bg_urgent or theme.secondary
    theme.bg_minimize = args.bg_minimize or theme.background
    theme.bg_systray = args.bg_systray or theme.background

    theme.fg_normal = args.fg_normal or theme.text
    theme.fg_focus = args.fg_focus or theme.text
    theme.fg_urgent = args.fg_urgent or theme.text
    theme.fg_minimize = args.fg_minimize or "#757575"

    -- Borders
    theme.border_width = args.border_width or beautiful.xresources.apply_dpi(2)
    theme.border_normal = args.border_normal or theme.background
    theme.border_focus = args.border_focus or theme.primary
    theme.border_marked = args.border_marked or theme.secondary

    -- Tasklist settings
    theme.tasklist_bg_normal = args.tasklist_bg_normal or theme.background
    theme.tasklist_bg_focus = args.tasklist_bg_focus or theme.primary
    theme.tasklist_bg_urgent = args.tasklist_bg_urgent or theme.secondary
    theme.tasklist_bg_minimize = args.tasklist_bg_minimize or theme.background

    theme.tasklist_fg_normal = args.tasklist_fg_normal or theme.text
    theme.tasklist_fg_focus = args.tasklist_fg_focus or theme.text
    theme.tasklist_fg_urgent = args.tasklist_fg_urgent or theme.text
    theme.tasklist_fg_minimize = args.tasklist_fg_minimize or "#757575"

    -- Titlebar settings
    theme.titlebar_bg_normal = args.titlebar_bg_normal or theme.background
    theme.titlebar_bg_focus = args.titlebar_bg_focus or theme.primary

    theme.titlebar_fg_normal = args.titlebar_fg_normal or theme.text
    theme.titlebar_fg_focus = args.titlebar_fg_focus or theme.text

    -- Notification settings
    theme.notification_bg = args.notification_bg or theme.background
    theme.notification_fg = args.notification_fg or theme.text
    theme.notification_border_color = args.notification_border_color or theme.primary
    theme.notification_border_width = args.notification_border_width or beautiful.xresources.apply_dpi(1)

    -- Tooltip settings
    theme.tooltip_bg = args.tooltip_bg or theme.background
    theme.tooltip_fg = args.tooltip_fg or theme.text
    theme.tooltip_border_color = args.tooltip_border_color or theme.primary
    theme.tooltip_border_width = args.tooltip_border_width or beautiful.xresources.apply_dpi(1)

    -- Menu settings
    theme.menu_bg_normal = args.menu_bg_normal or theme.background
    theme.menu_bg_focus = args.menu_bg_focus or theme.primary

    theme.menu_fg_normal = args.menu_fg_normal or theme.text
    theme.menu_fg_focus = args.menu_fg_focus or theme.text

    theme.menu_border_color = args.menu_border_color or theme.primary
    theme.menu_border_color = args.menu_border_color or theme.primary
    theme.menu_border_width = args.menu_border_width or beautiful.xresources.apply_dpi(1)
    theme.menu_height = args.menu_height or beautiful.xresources.apply_dpi(24)
    theme.menu_width = args.menu_width or beautiful.xresources.apply_dpi(160)

    -- Hotkey popup settings
    theme.hotkeys_bg = args.hotkeys_bg or theme.background
    theme.hotkeys_fg = args.hotkeys_fg or theme.text
    theme.hotkeys_border_width = args.hotkeys_border_width or beautiful.xresources.apply_dpi(1)
    theme.hotkeys_border_color = args.hotkeys_border_color or theme.primary
    theme.hotkeys_modifiers_fg = args.hotkeys_modifiers_fg or theme.secondary

    -- Prompt settings
    theme.prompt_bg = args.prompt_bg or theme.background
    theme.prompt_fg = args.prompt_fg or theme.text

    -- Set wallpaper
    theme.wallpaper = args.wallpaper or function(s)
        return gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end

    return theme
end

return create_advanced_theme
