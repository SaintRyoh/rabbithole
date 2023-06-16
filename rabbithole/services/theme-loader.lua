local beautiful = require("beautiful")
local naughty = require("naughty")
local nice = require("sub.nice")
local dpi = require("beautiful.xresources").apply_dpi

return setmetatable({}, {
    __constructor = function (
        settings,
        rabbithole__services__tesseractThemeEngine
    )
        local theme_table
        local theme_source = settings.theme.theme_dir
        -- TODO: still need to add logic here to pass the theme arguments from settings to tesseract
        theme_table = rabbithole__services__tesseractThemeEngine:generate_theme(theme_source)

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
            naughty.notify({title = "Error", text = "Failed to generate theme."})
        end

        return beautiful.get()
    end,
})
