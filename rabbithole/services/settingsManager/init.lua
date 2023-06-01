-- init file for rabbithole's settings manager service

local bling = require("bling")

local SettingsManager = {}
SettingsManager.__index = SettingsManager

function SettingsManager.new(settings)
    local self = setmetatable({}, SettingsManager)
    -- Add any settings you want to be part of the SettingsManager instance
    self.settings = settings or {}

    -- Create a tabbed GUI using bling
    self.tabbedGUI = bling.tabbed.new()

    -- Dynamically create tabs based on how many other modules are in the settingsManager directory
    local modules = require("pl.dir").getallfiles("services/settingsManager")
    for _, module in ipairs(modules) do
        if module ~= "init.lua" and module:sub(-4) == ".lua" then
            local tabName = module:sub(1, -5)
            local tabContent = require("services/settingsManager/" .. tabName)
            self.tabbedGUI:add(tabName, tabContent)
        end
    end

    return self
end

return SettingsManager
