local gears = require("gears")
local rubato = require("sub.rubato")

local AnimationService = {}
AnimationService.__index = AnimationService

RUBATO_DIR = "sub.rubato."
RUBATO_MANAGER = require("sub.rubato.manager")

function AnimationService.new(settings)
    local self = setmetatable({}, AnimationService)

    self.settings = settings --TODO: this needs to use the settings flat file

    return function (args)
        return rubato.timed(gears.table.crush(self.settings.animation or {}, args))
    end
end

function AnimationService:blink(args)
    local default_args = {
        period = 2, -- 2 seconds for a full period
        amplitude = 1, -- it will go from 0 to 1
        autostart = false -- manually start it
    }

    -- Merge default args and given args
    local complete_args = gears.table.crush(default_args, args)

    return rubato.timed_sinusoidal(complete_args)
end

return AnimationService
