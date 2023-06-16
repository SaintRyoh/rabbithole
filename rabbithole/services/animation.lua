local gears = require("gears")

local AnimationService = {}
AnimationService.__index = AnimationService

RUBATO_DIR = "sub.rubato."
RUBATO_MANAGER = require("sub.rubato.manager")

local rubato = require("sub.rubato")

function AnimationService.new(settings)
    local self = setmetatable({}, AnimationService)

    self.settings = settings --TODO: this needs to use the settings flat file

    return function (args)
        return rubato.timed(gears.table.crush(self.settings.animation or {}, args))
    end
end


return AnimationService