local awful = require('awful')
local gears = require('gears')
local __ = require('lodash')
local io = require('io')

local IconHandler = {}
IconHandler.__index = IconHandler

function IconHandler.new(settings)
    local self = setmetatable({}, IconHandler)
    self.settings = settings

    return self
end

-- gsettings get org.gnome.desktop.interface icon-theme
-- get current icon theme
local function get_current_icon_theme()
    local cmd = "gsettings get org.gnome.desktop.interface icon-theme"
    local handle = io.popen(cmd)
    if handle == nil then
        return nil
    end
    local result = handle:read("*a")
    handle:close()
    return result:gsub("\n", ""):gsub("'", "")
end

function IconHandler:get_icon_by_client(c)
    local icon = c.icon or c.class_icon or c.instance_icon or nil
    local theme = get_current_icon_theme()
    local theme_path = nil
    if theme then
        theme_path = '/usr/share/icons/' .. theme .. '/apps/scalable/'
    end

    return icon or gears.surface.load_uncached_silently(
        awful.util.geticonpath(
            c.class:lower(), 
            gears.table.join(__.get(self.settings, {'client', 'icon', 'ext' }), {'svg', 'png', 'gif'}),
            gears.table.join(__.get(self.settings, {'client', 'icon', 'dirs' }), {theme_path, '/usr/share/pixmaps/'})
        ) or nil, 
        __.get(self.settings, {'client', 'icon', 'default' },
        gears.filesystem.get_configuration_dir() .. "themes/rabbithole/icons/fallback.svg"
        )

    )
end

return IconHandler
