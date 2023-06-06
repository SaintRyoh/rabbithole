local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local SettingsManager = {}
SettingsManager.__index = SettingsManager

function SettingsManager.new(settings)
    local self = setmetatable({}, SettingsManager)

    self.settings = settings or {}

    self.window = wibox({
        width = 800,
        height = 600,
        ontop = true,
        visible = false,
    })

    self.layout = wibox.layout.fixed.vertical()
    self.window:set_widget(self.layout)

    self.tabs = {}

    for category, values in pairs(self.settings) do
        local tabButton = wibox.widget.textbox(category)
        tabButton:connect_signal("button::press", function()
            self:showTab(category)
        end)
        self.layout:add(tabButton)
        self.tabs[category] = values
    end

    return self
end

function SettingsManager:showTab(category)
    local settings = self.tabs[category]
    if settings then
        self.layout:reset()
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
