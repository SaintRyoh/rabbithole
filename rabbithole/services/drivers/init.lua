local DriverStrategyFactory = {}
DriverStrategyFactory.__index = DriverStrategyFactory

function DriverStrategyFactory.new(settings)
    local self = setmetatable({}, DriverStrategyFactory)
    self.settings = settings.drivers

    return self
end

function DriverStrategyFactory:volume_up()
    return require("rabbithole.components.keys.drivers.volume_up." .. self.settings.volume_up.driver.name)(self.settings.volume_up.driver.opts)
end

return DriverStrategyFactory