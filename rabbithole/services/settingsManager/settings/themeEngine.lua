local wibox = require("wibox")
local beautiful = require("beautiful")

local Theme = {}
Theme.__index = Theme

function Theme.new(tesseractThemeEngine)
    local self = setmetatable({}, Theme)

    self.themeEngine = tesseractThemeEngine

    self.themeSource = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Enter theme source here",
    }

    self.themeSourceType = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Enter source type here",
    }

    self.applyButton = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Apply Theme",
    }
    self.applyButton:connect_signal("button::release", function()
        self:applyTheme()
    end)

    local layout = wibox.layout.fixed.vertical()
    layout:add(self.themeSource, self.themeSourceType, self.applyButton)
    local tab = bling.module.tabbed.add("Theme", layout)

    return self
end

function Theme:applyTheme()
    local themeTable = self.themeEngine.generate_theme(self.themeSource.text, self.themeSourceType.text)
    if themeTable then
        beautiful.init(themeTable)
    else
        naughty.notify({ title = "Error", text = "Failed to apply theme." })
    end
end

return Theme
