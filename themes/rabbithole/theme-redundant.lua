--[[ Table of the redunant spiderweb of theme variables that gives Rabbithole
it's consistent look and feel.
]]
   -- Turned this into a function to prevent any circular references.
local function apply_redundancies(theme)
    -- [[[ Backgrounds and borders
    theme.bg_urgent = theme.info
    theme.bg_systray = theme.neutral

    theme.border_normal = theme.base_color
    theme.border_focus = theme.secondary_color
    theme.border_marked = theme.danger
    -- ]]]

    -- [[[ Taglist variables
    theme.taglist_bg_normal = theme.bg_normal
    theme.taglist_bg_empty = theme.taglist_bg_normal
    theme.taglist_bg_focus = theme.bg_focus
    theme.taglist_fg_focus = theme.fg_focus
    theme.taglist_fg_empty = theme.fg_focus
    theme.taglist_container_bg = theme.bg_normal
    -- ]]]

    -- [[[ Tasklist variables
    theme.tasklist_bg_normal = theme.neutral
    theme.tasklist_bg_focus = theme.bg_focus
    theme.tasklist_shape_border_color = theme.tasklist_bg_normal
    theme.tasklist_shape_border_color_minimized = theme.taglist_bg_neutral
    -- ]]]
    theme.notification_bg = theme.neutral
    theme.notification_fg = theme.white
    theme.notification_border_color = theme.base_color
    
    -- [[[ Hotkeys popup variables
    theme.hotkeys_bg = theme.bg_normal
    -- ]]]
    -- [[[ BLING theme variables
    theme.tag_preview_client_border_color = theme.base_color
    theme.tag_preview_widget_border_color = theme.neutral
    -- ]]]
end

return apply_redundancies
