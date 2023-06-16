local wibox = require("wibox")
local bling = require("sub.bling")
local Tesseract = require("rabbithole.services.tesseractThemeEngine")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears.filesystem")

local function table_to_string(tbl)
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        done[k] = true
        result[k] = tostring(v)
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, k .. "=" .. tostring(v))
        end
    end
    return "{" .. table.concat(result, ",") .. "}"
end

return function()

    -- Appearance settings
    local Appearance = {}
    Appearance.settings = {}

    -- settings file , concatenates get_configuration_dir() plus 
    local settings_file = gears.get_configuration_dir() .. "settings.lua"

    -- GUI elements for changing appearance settings
    Appearance.primaryColorSetting = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Enter primary color here"
    }

    Appearance.colorSchemeSetting = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Enter color scheme here"
    }

    Appearance.fontSetting = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Enter font name here"
    }

    Appearance.iconPackSetting = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Enter icon pack name here"
    }

    -- Save button for applying changes
    Appearance.saveButton = wibox.widget {
        widget = wibox.widget.textbox,
        text = "Save changes"
    }
    Appearance.saveButton:connect_signal("button::release", function()
        Appearance:saveSettings()
    end)

    local layout = wibox.layout.fixed.vertical()
    layout:add(Appearance.primaryColorSetting, Appearance.colorSchemeSetting, Appearance.fontSetting,
        Appearance.iconPackSetting, Appearance.saveButton)

    -- Load current settings
    Appearance:loadSettings()

    function Appearance:loadSettings()
        local file, err = io.open(settings_file, "r")
        if file then
            local func, err = load(file:read("*all"), "settings", "t", {})
            file:close()
            if func then
                self.settings = func() or {}
                self.primaryColorSetting.text = self.settings.primaryColor or "Enter primary color here"
                self.colorSchemeSetting.text = self.settings.colorScheme or "Enter color scheme here"
                self.fontSetting.text = self.settings.font or "Enter font name here"
                self.iconPackSetting.text = self.settings.iconPack or "Enter icon pack name here"
            else
                naughty.notify({
                    title = "Error",
                    text = "Failed to load settings: " .. err
                })
            end
        else
            naughty.notify({
                title = "Error",
                text = "Failed to open settings file: " .. err
            })
        end
    end

    function Appearance:saveSettings()
        self.settings = {
            primaryColor = self.primaryColorSetting.text,
            colorScheme = self.colorSchemeSetting.text,
            font = self.fontSetting.text,
            iconPack = self.iconPackSetting.text
        }
        local file, err = io.open(settings_file, "w")
        if file then
            file:write("return " .. table_to_string(self.settings))
            file:close()
        else
            naughty.notify({
                title = "Error",
                text = "Failed to open settings file for writing: " .. err
            })
        end

        -- Create a new Tesseract instance
        local tesseractInstance = Tesseract.new()

        -- Generate theme
        local theme_table = tesseractInstance:generate_theme(nil, self.primaryColorSetting.text,
            self.colorSchemeSetting.text, {
                font = self.fontSetting.text
                -- include other options you want to customize here
            })

        -- Apply new theme
        beautiful.init(theme_table)
    end

    return layout, "Appearance"
end
