local wibox = require("wibox")
local gears = require("gears")
local dir = require("pl.dir")

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
    local modules = dir.getallfiles(self.directory)
    for _, module in ipairs(modules) do
        if module:sub(-4) == ".lua" then
            local filePath = module:sub(self.directory:len() + 1, -1)
            local moduleName = filePath:sub(1, -5)
            local tabButton = wibox.widget.textbox(moduleName)
            tabButton:connect_signal("button::press", function()
                self:showTab(moduleName)
            end)
            self.layout:add(tabButton)

            -- Load the module and save its content
            local moduleContent = require("rabbithole.services.settingsManager." .. moduleName)
            self.tabs[moduleName] = moduleContent
        end
    end

    return self
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
