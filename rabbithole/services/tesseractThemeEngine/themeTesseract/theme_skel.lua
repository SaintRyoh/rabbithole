local gears = require("gears")
local beautiful = require("beautiful")


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

--[[ Bling theme variables template
This file has all theme variables of the bling module.
Every variable has a small comment on what it does.
You might just want to copy that whole part into your theme.lua and start adjusting from there.
--]]

-- window swallowing
theme.dont_swallow_classname_list    = {"firefox", "Gimp"}      -- list of class names that should not be swallowed
theme.dont_swallow_filter_activated  = true                     -- whether the filter above should be active

-- flash focus
theme.flash_focus_start_opacity = 0.6       -- the starting opacity
theme.flash_focus_step = 0.01               -- the step of animation

-- playerctl signal
theme.playerctl_backend = "playerctl_cli"     -- backend to use
theme.playerctl_ignore = {}                   -- list of players to be ignored
theme.playerctl_player = {}                   -- list of players to be used in priority order
theme.playerctl_update_on_activity = true     -- whether to prioritize the most recently active players or not
theme.playerctl_position_update_interval = 1  -- the update interval for fetching the position from playerctl

-- tabbed
theme.tabbed_spawn_in_tab = false           -- whether a new client should spawn into the focused tabbing container

-- tabbar general
theme.tabbar_ontop  = false
theme.tabbar_radius = 0                -- border radius of the tabbar
theme.tabbar_style = "default"         -- style of the tabbar ("default", "boxes" or "modern")
theme.tabbar_font = "Sans 11"          -- font of the tabbar
theme.tabbar_size = 40                 -- size of the tabbar
theme.tabbar_position = "top"          -- position of the tabbar
theme.tabbar_bg_normal = "#000000"     -- background color of the focused client on the tabbar
theme.tabbar_fg_normal = "#ffffff"     -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus  = "#1A2026"     -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus  = "#ff0000"     -- foreground color of unfocused clients on the tabbar
theme.tabbar_bg_focus_inactive = nil   -- background color of the focused client on the tabbar when inactive
theme.tabbar_fg_focus_inactive = nil   -- foreground color of the focused client on the tabbar when inactive
theme.tabbar_bg_normal_inactive = nil  -- background color of unfocused clients on the tabbar when inactive
theme.tabbar_fg_normal_inactive = nil  -- foreground color of unfocused clients on the tabbar when inactive
theme.tabbar_disable = false           -- disable the tab bar entirely

-- mstab
theme.mstab_bar_disable = false             -- disable the tabbar
theme.mstab_bar_ontop = false               -- whether you want to allow the bar to be ontop of clients
theme.mstab_dont_resize_slaves = false      -- whether the tabbed stack windows should be smaller than the
                                            -- currently focused stack window (set it to true if you use
                                            -- transparent terminals. False if you use shadows on solid ones
theme.mstab_bar_padding = "default"         -- how much padding there should be between clients and your tabbar
                                            -- by default it will adjust based on your useless gaps.
                                            -- If you want a custom value. Set it to the number of pixels (int)
theme.mstab_border_radius = 0               -- border radius of the tabbar
theme.mstab_bar_height = 40                 -- height of the tabbar
theme.mstab_tabbar_position = "top"         -- position of the tabbar (mstab currently does not support left,right)
theme.mstab_tabbar_style = "default"        -- style of the tabbar ("default", "boxes" or "modern")
                                            -- defaults to the tabbar_style so only change if you want a
                                            -- different style for mstab and tabbed

-- the following variables are currently only for the "modern" tabbar style
theme.tabbar_color_close = "#f9929b"        -- chnges the color of the close button
theme.tabbar_color_min   = "#fbdf90"        -- chnges the color of the minimize button
theme.tabbar_color_float = "#ccaced"        -- chnges the color of the float button

-- tag preview widget
theme.tag_preview_widget_border_radius = 0          -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 0          -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 0.5              -- Opacity of each client
theme.tag_preview_client_bg = "#000000"             -- The bg color of each client
theme.tag_preview_client_border_color = "#ffffff"   -- The border color of each client
theme.tag_preview_client_border_width = 3           -- The border width of each client
theme.tag_preview_widget_bg = "#000000"             -- The bg color of the widget
theme.tag_preview_widget_border_color = "#ffffff"   -- The border color of the widget
theme.tag_preview_widget_border_width = 3           -- The border width of the widget
theme.tag_preview_widget_margin = 0                 -- The margin of the widget

-- task preview widget
theme.task_preview_widget_border_radius = 0          -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = "#000000"             -- The bg color of the widget
theme.task_preview_widget_border_color = "#ffffff"   -- The border color of the widget
theme.task_preview_widget_border_width = 3           -- The border width of the widget
theme.task_preview_widget_margin = 0                 -- The margin of the widget

-- tabbed misc widget(s)
theme.bling_tabbed_misc_titlebar_indicator = {
    layout_spacing = dpi(4),
    icon_size = dpi(20),
    icon_margin = dpi(4),
    bg_color_focus = "#ff0000",
    bg_color = "#00000000",
    icon_shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 0)
    end,
    layout = wibox.layout.fixed.horizontal
}

-- window switcher widget
theme.window_switcher_widget_bg = "#000000"              -- The bg color of the widget
theme.window_switcher_widget_border_width = 3            -- The border width of the widget
theme.window_switcher_widget_border_radius = 0           -- The border radius of the widget
theme.window_switcher_widget_border_color = "#ffffff"    -- The border color of the widget
theme.window_switcher_clients_spacing = 20               -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 5 -- The space between client icon and text
theme.window_switcher_client_width = 150                 -- The width of one client widget
theme.window_switcher_client_height = 250                -- The height of one client widget
theme.window_switcher_client_margins = 10                -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = 10             -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = false                            -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins = 10                  -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = "center"             -- How to vertically align one clients title
theme.window_switcher_name_forced_width = 200            -- The width of one title
theme.window_switcher_name_font = "sans 11"              -- The font of all titles
theme.window_switcher_name_normal_color = "#ffffff"      -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color = "#ff0000"       -- The color of one title if the client is focused
theme.window_switcher_icon_valign = "center"             -- How to vertically align the one icon
theme.window_switcher_icon_width = 40                    -- The width of one icon
