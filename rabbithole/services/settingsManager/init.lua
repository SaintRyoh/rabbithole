local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local SettingsManager = {}
SettingsManager.__index = SettingsManager

function SettingsManager.new(settings)
    local self = setmetatable({}, SettingsManager)

    self.settings = settings or {}
    self.directory = gears.filesystem.get_configuration_dir() .. "rabbithole/services/settingsManager/"
    self.settings_file = gears.filesystem.get_configuration_dir() .. "settings.lua"

    self.layout = wibox.layout.fixed.vertical()

    local titlebar = wibox.widget.textbox("Settings Manager")
    titlebar.font = "Ubuntu Bold 14"
    titlebar.align = "center"
    self.layout:add(titlebar)

    self.window = awful.popup({
        widget = self.layout,
        ontop = true,
        visible = false,
        placement = awful.placement.centered, -- changed placement to centered
        offset = { y = 5 },
        shape = gears.shape.rounded_rect, -- added shape property
        border_width = 2, -- added border_width property
        border_color = "#ffffff" -- added border_color property
    })

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
    local p = io.popen('ls "' .. directory .. '"')
    for file in p:lines() do
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