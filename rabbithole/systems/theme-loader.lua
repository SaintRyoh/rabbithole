local beautiful = require("beautiful")
local naughty = require("naughty")
local nice = require("sub.nice")

return setmetatable({}, {
    __constructor = function (
        settings,
        rabbithole__services__tesseractThemeEngine
    )
        local theme_table
        local theme_source = settings.theme_dir

        theme_table = rabbithole__services__tesseractThemeEngine:generate_theme(theme_source)

        if theme_table then
            beautiful.init(theme_table)
            nice{
                titlebar_height =  35,
                titlebar_radius = 13,
                titlebar_font = beautiful.font,
                no_titlebar_maximized = true,
                titlebar_items = {
                    left = {"floating", "ontop", "sticky"},
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
