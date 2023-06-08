local wibox = require("wibox")
local gears = require("gears")

local SettingsManager = {}
SettingsManager.__index = SettingsManager

function SettingsManager.new(settings)
    local self = setmetatable({}, SettingsManager)

    self.settings = settings or {}
    -- settings manager directory
    self.directory = gears.filesystem.get_configuration_dir() .. "rabbithole/services/settingsManager/"
    self.settings_file = gears.filesystem.get_configuration_dir() .. "settings.lua"

    self.window = wibox({
        width = 800,
        height = 600,
        ontop = true,
        visible = false,
    })

    self.layout = wibox.layout.fixed.vertical()
    self.window:set_widget(self.layout)

    -- Add a "titlebar" to the wibox
    local titlebar = wibox.widget.textbox("Settings Manager")
    titlebar.font = "Sans Bold 14"
    titlebar.align = "center"
    self.layout:add(titlebar)

    self.tabs = {}

    -- Dynamically create tabs based on the modules in the "settingsManager" directory
    local modules = self:loadModulesFromDirectory(self.directory)
    for _, moduleName in ipairs(modules) do
        local tabButton = wibox.widget.textbox(moduleName)
        tabButton:connect_signal("button::press", function()
            self:showTab(moduleName)
        end)
        self.layout:add(tabButton)

        -- Load the module and save its content
        local moduleContent = require("rabbithole.services.settingsManager." .. moduleName)
        self.tabs[moduleName] = moduleContent
    end

    return self
end

-- Loads all Lua module names from a directory
function SettingsManager:loadModulesFromDirectory(directory)
    local modules = {}
    local p = io.popen('ls "' .. directory .. '"')  -- Open directory look for files
    for file in p:lines() do                         -- Loop through all files
        if file:sub(-4) == ".lua" then
            local moduleName = file:sub(1, -5)
            table.insert(modules, moduleName)
        end
    end
    p:close()
    return modules
end

function SettingsManager:showTab(moduleName)
    local settings = self.tabs[moduleName]
    if settings then
        self.layout:reset()

        -- Add the "titlebar" again after reset
        local titlebar = wibox.widget.textbox("Settings Manager - " .. moduleName)
        titlebar.font = "Sans Bold 14"
        titlebar.align = "center"
        self.layout:add(titlebar)

        for key, value in pairs(settings) do
            local row = wibox.widget.textbox(key .. ": " .. tostring(value))
            self.layout:add(row)
        end
    end
end

function SettingsManager:show()
    self.window.visible = true
end

function SettingsManager:hide()
    self.window.visible = false
end

return SettingsManager
