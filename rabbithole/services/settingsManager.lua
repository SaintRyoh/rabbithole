-- Create the Settings object so it's seen by the dependency injector
local Settings = { }
Settings.__index = Settings

function Settings.new()
    local self = setmetatable({}, Settings)

    -- Load the user's settings
    self.settings = dofile("settings.lua")

    return self
end

return Settings
