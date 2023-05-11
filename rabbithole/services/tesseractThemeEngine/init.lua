local http = require("socket.http")
local chromaticTesseract = require("rabbithole.services.tesseractThemeEngine.chromaticTesseract")
local naughty = require("naughty")

--[[ Usage:
local Tesseract = require("rabbithole.services.tesseractThemeEngine")

-- Create a new Tesseract instance
local tesseractInstance = Tesseract.new({setting1 = value1, setting2 = value2})

-- Use a GitHub URL to fetch the theme. This will return the theme table
local theme_table = tesseractInstance:generate_theme("https://raw.githubusercontent.com/user/repo/branch/theme_file.lua")

-- Use a local file to fetch the theme. This will return the theme table
local theme_table = tesseractInstance:generate_theme("/path/to/your/theme/file.lua")

-- Use chromaticTesseract to generate theme. This will return the theme table
local theme_table = tesseractInstance:generate_theme(nil, "#4CAF50", "complementary", {
    saturation_range = 0.1,
    lightness_range = 0.1,
    font = "Roboto 12",
    fg_normal = "#FFFFFF",
    fg_focus = "#000000",
    extra_roles = {
        urgent = "color3",
        minimize = "color4"
    }
})

-- Then apply theme with beautiful.init(theme_table)
]]
local Tesseract = {}
Tesseract.__index = Tesseract

function Tesseract.new(settings)
    local self = setmetatable({}, Tesseract)
    -- Add any settings you want to be part of the Tesseract instance
    self.settings = settings or {}
    return self
end

-- Fetch theme content from a GitHub URL
function Tesseract:fetch_theme_from_github(url)
    local content = http.request(url)
    if content then
        return loadstring(content)()
    else
        naughty.notify({ title = "Error", text = "Failed to fetch theme from GitHub URL." })
        return nil
    end
end

-- Read theme content from a local file
function Tesseract:read_theme_from_file(file_path)
    local file, err = io.open(file_path, "r")
    if not file then
        naughty.notify({ title = "Error", text = "Failed to read theme from local file: " .. err })
        return nil
    end
    local content = file:read("*all")
    file:close()
    return loadstring(content)()
end

-- Main function to handle theme fetching
-- @This function can handle any of theme types and detect it automatically.
function Tesseract:generate_theme(theme_source, primary_color, color_scheme, options)
    local theme_table = nil

    -- Case: Generate theme from chromaticTesseract
    if primary_color and color_scheme then
        theme_table = chromaticTesseract.generate_theme(primary_color, color_scheme, options)
        -- Case: Generate theme from GitHub URL
    elseif type(theme_source) == "string" and string.match(theme_source, "^https://") then
        theme_table = self:fetch_theme_from_github(theme_source)
        -- Case: Generate theme from local file
    elseif type(theme_source) == "string" then
        theme_table = self:read_theme_from_file(theme_source)
    else
        naughty.notify({ title = "Error", text = "Invalid theme source." })
        return
    end

    return theme_table
end

return Tesseract
