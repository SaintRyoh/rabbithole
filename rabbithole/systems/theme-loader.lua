local beautiful = require("beautiful")

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
        else
            naughty.notify({title = "Error", text = "Failed to generate theme."})
        end

        return beautiful.get()
    end,
})
