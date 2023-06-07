--[[ Settings file for Rabbithole

Creates a settings object to be used with the settingsManager service.
]]

local Settings = { }
Settings.__index = Settings

function Settings.new(settings)
    local self = setmetatable({ }, Settings)
    -- TODO:
    -- Define settings variables and their defaults
    -- Create a default settings table (type: dictionary)
    self.settings = { }

end