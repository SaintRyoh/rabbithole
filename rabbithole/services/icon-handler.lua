local awful = require('awful')
local gears = require('gears')
local __ = require('lodash')

IconHandler = {}
IconHandler.__index = IconHandler

function IconHandler.new(settings)
    local self = setmetatable({}, IconHandler)
    self.settings = settings

    return self
end

function IconHandler:get_icon_by_client(c)
    --Debugger.dbg()
    local icon = c.icon or c.class_icon or c.instance_icon or nil
    
    return icon or gears.surface.load_uncached_silently(
        awful.util.geticonpath(
            c.class:lower(), 
            __.get(self.settings, {'client', 'icon', 'ext' }),
            __.get(self.settings, {'client', 'icon', 'dirs' })
        ) or nil, 
        __.get(self.settings, {'client', 'icon', 'default' },
        gears.filesystem.get_configuration_dir() .. "themes/rabbithole/icons/fallback.svg"
        )

    )
end

return IconHandler
