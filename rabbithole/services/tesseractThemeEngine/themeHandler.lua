local http = require("socket.http")
local chromaticTesseract = require("chromaticTesseract")
local beautiful = require("beautiful")

--[[ Usage:
local themeHandler = require("themeHandler")

-- Use a GitHub URL to fetch the theme. This will return the theme table
local theme_table = themeHandler.generate_theme("https://raw.githubusercontent.com/user/repo/branch/theme_file.lua", "github")

-- Use a local file to fetch the theme. This will return the theme table
local theme_table = themeHandler.generate_theme("/path/to/your/theme/file.lua", "local")

-- Use chromaticTesseract to generate theme. This will return the theme table
local theme_table = themeHandler.generate_theme(nil, nil, "#4CAF50", "complementary", {
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

Then apply theme with beautiful.init(theme_table)
]]

local http = require("socket.http")
local chromaticTesseract = require("chromaticTesseract")
local naughty = require("naughty")

local themeHandler = {}

-- Fetch theme content from a GitHub URL
local function fetch_theme_from_github(url)
    local content = http.request(url)
    if content then
        return loadstring(content)()
    else
        naughty.notify({title = "Error", text = "Failed to fetch theme from GitHub URL."})
        return nil
    end
end

-- Read theme content from a local file
local function read_theme_from_file(file_path)
    local file, err = io.open(file_path, "r")
    if not file then
        naughty.notify({title = "Error", text = "Failed to read theme from local file: " .. err})
        return nil
    end
    local content = file:read("*all")
    file:close()
    return loadstring(content)()
end

-- Main function to handle theme fetching
-- @This function can handle any of theme types and detects it automatically.
function themeHandler.generate_theme(theme_source, source_type, primary_color, color_scheme, options)
    local theme_table = nil

    if primary_color and color_scheme then
        theme_table = chromaticTesseract.generate_theme(primary_color, color_scheme, options)
    else
        if source_type == "github" then
            theme_table = fetch_theme_from_github(theme_source)
        elseif source_type == "local" then
            theme_table = read_theme_from_file(theme_source)
        else
            naughty.notify({title = "Error", text = "Invalid theme source type."})
            return
        end
    end

    return theme_table
end

return themeHandler
