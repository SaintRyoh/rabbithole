--[[
█▄▄▄▄ ██   ███   ███   ▄█    ▄▄▄▄▀ ▄  █ ████▄ █     ▄███▄
█  ▄▀ █ █  █  █  █  █  ██ ▀▀▀ █   █   █ █   █ █     █▀   ▀
█▀▀▌  █▄▄█ █ ▀ ▄ █ ▀ ▄ ██     █   ██▀▀█ █   █ █     ██▄▄
█  █  █  █ █  ▄▀ █  ▄▀ ▐█    █    █   █ ▀████ ███▄  █▄   ▄▀
  █      █ ███   ███    ▐   ▀        █            ▀ ▀███▀
 ▀      █                           ▀

Rabbithole's Default Theme

 --]]

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- make theme variables global
theme_path = awful.util.getdir("config") .. "/src/themes/rabbithole/"
Theme = {}

dofile(theme_path .. "theme_variables.lua")

Theme.awesome_icon = theme_path .. "../../assets/icons/ArchLogo.png"
Theme.awesome_subicon = theme_path .. "../../assets/icons/ArchLogo.png"
-- Wallpaper
beautiful.wallpaper = user_vars.wallpaper
screen.connect_signal(
    'request::wallpaper',
    function(s)
    if beautiful.wallpaper then
        if type(beautiful.wallpaper) == 'string' then
            gears.wallpaper.maximized(beautiful.wallpaper, s)
        else
            beautiful.wallpaper(s)
        end
    end
end
)

beautiful.init(Theme)
