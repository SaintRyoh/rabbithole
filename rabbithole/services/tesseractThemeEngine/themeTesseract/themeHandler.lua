local http = require("socket.http")
local chromaticTesseract = require("chromaticTesseract")
local beautiful = require("beautiful")

--[[ Usage:
local themeHandler = require("themeHandler")

-- Use a GitHub URL to set the theme
themeHandler.set_theme("https://raw.githubusercontent.com/user/repo/branch/theme_file.lua", "github")

-- Use a local file to set the theme
themeHandler.set_theme("/path/to/your/theme/file.lua", "local")
]]
local themeHandler = {}

-- Fetch theme content from a GitHub URL
local function fetch_theme_from_github(url)
    local content = http.request(url)
    if content then
        return content
    else
        print("Error: Failed to fetch theme from GitHub URL.")
        return nil
    end
end

-- Read theme content from a local file
local function read_theme_from_file(file_path)
    local file, err = io.open(file_path, "r")
    if not file then
        print("Error: Failed to read theme from local file: " .. err)
        return nil
    end
    local content = file:read("*all")
    file:close()
    return content
end

-- Apply theme using Beautiful.init()
local function apply_theme(theme_table)
    beautiful.init(theme_table)
end

-- Main function to handle theme fetching and application
function themeHandler.set_theme(theme_source, source_type, primary_color, color_scheme, options)
    local theme_content = nil
    local theme_table = nil

    if primary_color and color_scheme then
        theme_table = chromaticTesseract.generate_theme(primary_color, color_scheme, options)
    else
        if source_type == "github" then
            theme_content = fetch_theme_from_github(theme_source)
        elseif source_type == "local" then
            theme_content = read_theme_from_file(theme_source)
        else
            -- Would I inject the error_hander here?
            naughty.notify("Error: Invalid theme source type.")
            return
        end

        if theme_content then
            theme_table = theme_generator.generate_theme(theme_content)
        end
    end

    if theme_table then
        apply_theme(theme_table)
    end
end

return themeHandler
