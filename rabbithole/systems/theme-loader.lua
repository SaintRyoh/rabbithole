local beautiful = require("beautiful")
local gears = require("gears")


return setmetatable({}, {
    __constructor = function (
        settings,
        rabbithole__services__tesseractThemeEngine
    )
        -- here you could do something like
        -- if settings.theme.type == "basic" then
        --  beautiful.init(rabbithole__services__tesseractThemeEngine:generate_theme_from_color())
        -- end
        
        -- if settings.type == "basic" then
        --     beautiful.init(rabbithole__services__tesseractThemeEngine:generate_theme_from_color())
        -- elseif settings.type == "file" then
        --     beautiful.init(rabbithole__services__tesseractThemeEngine:generate_theme_from_file())
        -- elseif settings.type == "wallpaper" then
        --     beautiful.init(rabbithole__services__tesseractThemeEngine:generate_theme_from_wallpaper())
        -- elseif settings.type == "random" then
        --     beautiful.init(rabbithole__services__tesseractThemeEngine:generate_theme_randomly())
        -- elseif settings.type == "url" then
        --     beautiful.init(rabbithole__services__tesseractThemeEngine:generate_theme_from_url())
        -- end

        if gears.filesystem.file_readable(gears.filesystem.get_configuration_dir() .. settings.theme_dir) then
            beautiful.init(gears.filesystem.get_configuration_dir() .. settings.theme_dir)
        else
            beautiful.init("themes/default/theme.lua")
        end
        return beautiful.get()
    end,
})