local gears = require("gears")
local beautiful = require("beautiful")

local function hsl_to_rgb(h, s, l)
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        local hue_to_rgb = function(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q

        r = hue_to_rgb(p, q, h + 1/3)
        g = hue_to_rgb(p, q, h)
        b = hue_to_rgb(p, q, h - 1/3)
    end

    return r * 255, g * 255, b * 255
end

local function wrap_degrees(degrees)
    if degrees < 0 then
        return degrees + 360
    elseif degrees >= 360 then
        return degrees - 360
    else
        return degrees
    end
end

local function generate_colors(primary_color, color_scheme, options)
    local h, s, l = gears.color.parse_color(primary_color)
    local colors = {}

    local h_degrees = h * 360
    local schemes = {
        monochromatic = {0},
        analogous = {-30, 30},
        complementary = {180},
        split_complementary = {150, 210},
        triadic = {120, 240},
        tetradic = {90, 180, 270}
    }

    if not schemes[color_scheme] then
        error("Invalid color scheme. Available schemes are: monochromatic, analogous, complementary, split_complementary, triadic, tetradic.")
    end

    for i, offset in ipairs(schemes[color_scheme]) do
        local new_h = wrap_degrees(h_degrees + offset) / 360
        local new_s = math.min(math.max(s + (options.saturation_range or 0) * (i - 1), 0), 1)
        local new_l = math.min(math.max(l + (options.lightness_range or 0) * (i - 1), 0), 1)
        local r, g, b = hsl_to_rgb(new_h, new_s, new_l)
        colors["color" .. i] = string.format("#%02x%02x%02x", r, g, b)
    end

    return colors
end

local function generate_theme(primary_color, color_scheme, options)
    options = options or {}
    local theme = {}

    -- Generate color palette
    local colors = generate_colors(primary_color, color_scheme, options)

    -- Apply the color palette to the theme
    for k, v in pairs(colors) do
        theme[k] = v
    end

    -- Apply other Material Design 3 standards for theme
    theme.font = options.font or "Roboto 10"
    theme.bg_normal = theme.color1
    theme.bg_focus = theme.color2
    theme.fg_normal = options.fg_normal or "#FFFFFF"
    theme.fg_focus = options.fg_focus or "#000000"

    -- Customize additional color roles if needed
    if options.extra_roles then
        for role, color_key in pairs(options.extra_roles) do
            theme[role] = theme[color_key]
        end
    end

    return theme
end

--[[ Usage example:
local primary_color = "#4CAF50" -- Material Design Green 500
local color_scheme = "complementary" -- You can choose from the schemes listed above
local options = {
    saturation_range = 0.1,
    lightness_range = 0.1,
    font = "Roboto 12",
    fg_normal = "#FFFFFF",
    fg_focus = "#000000",
    extra_roles = {
        urgent = "color3",
        minimize = "color4"
    }
}
--]]
local tesseract_theme = generate_theme(primary_color, color_scheme, options)

-- Return the the MD3 color-perfect theme
return tesseract_theme
