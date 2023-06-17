local beautiful = require("beautiful")
local naughty = require("naughty")
local nice = require("sub.nice")
local dpi = require("beautiful.xresources").apply_dpi
local config_dir = require("gears.filesystem").get_configuration_dir()

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
        --elseif settings.theme.use_default then -- not implemented yet, cause it works without it
        --    theme_table = config_dir .. theme_template
        else
            -- Generate the theme from the template
            theme_table = tesseract_engine:generate_theme(theme_template)
            -- Now, override the theme with user's settings
            for key, value in pairs(settings.theme) do
                if theme_table[key] == "wallpaper" then
                    theme_table[key] = config_dir .. value
                else
                    theme_table[key] = value
                end
            end
        end

        if theme_table then
            beautiful.init(theme_table)
            nice{
                titlebar_height = dpi(34), -- keep the same size as the wibar for consistency
                titlebar_radius = dpi(13),
                titlebar_font = beautiful.font,
                button_size = dpi(20),
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
                    border_width = dpi(3),
                    fg_focus = beautiful.fg_focus,
                    fg_normal = beautiful.fg_normal,
                    font = beautiful.font,
                    height = dpi(27.5),
                    width = dpi(250),
                }
            }
        else
            naughty.notify({title = "Error", text = "Failed to initialize theme. Reverting back to default."})
        end

        return beautiful.get()
    end,
})

