local beautiful = require("beautiful")
local naughty = require("naughty")
local nice = require("sub.nice")
local dpi = require("beautiful.xresources").apply_dpi

return setmetatable({}, {
    __constructor = function (
        settings,
        rabbithole__services__tesseractThemeEngine
    )
        local tesseract_engine = rabbithole__services__tesseractThemeEngine
        
        local theme_table = settings.theme
        local theme_template = settings.theme.theme_template

        -- generate theme if toggled in settings
        if settings.theme.generate_theme then
            theme_table = tesseract_engine:generate_theme(nil, theme_table.base_color, theme_table.color_scheme)

        elseif settings.theme.use_default then -- not implemented yet, cause it works without it
            theme_table = theme_template
        else
            theme_table = tesseract_engine:generate_theme(theme_template)
            theme_table = settings.theme
        end

        if theme_table then
            beautiful.init(theme_table)
            nice{
                titlebar_height =  dpi(34), -- keep the same size as the wibar for consistency
                titlebar_radius = 13,
                titlebar_font = beautiful.font,
                button_size = 20,
                minimize_color = "#5125e5",
                maximize_color = "#30ff48",
                close_color = "#de1167",
                titlebar_items = {
                    left = { },
                    middle = "title",
                    right = {"minimize", "maximize", "close"},
                },
                context_menu_theme = {
                    bg_focus = beautiful.bg_focus,
                    bg_normal = beautiful.bg_normal,
                    border_color = beautiful.border_focus,
                    border_width = 3,
                    fg_focus =  beautiful.fg_focus,
                    fg_normal = beautiful.fg_normal,
                    font = beautiful.font,
                    height = 27.5,
                    width = 250,
                }
            }
        else
            naughty.notify({title = "Error", text = "Failed to initialize theme. Reverting back to default."})
        end

        return beautiful.get()
    end,
})
