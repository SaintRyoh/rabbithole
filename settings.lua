--[[ Settings flat file for Rabbithole

Returns a settings object to be used with the settingsManager service.
]]

return {
    -- General settings
    theme = "dark",
    terminal = "alacritty",
    browser = "firefox",
    editor = "nvim",

    -- AwesomeWM specific settings
    modkey = "Mod4",
    altkey = "Mod1",

    -- Layouts
    layouts = {
        "tile", 
        "float",
        -- add more layout types as needed...
    },

    -- Tags (workspaces) names
    tag_names = {
        "www",
        "dev",
        "sys",
        "doc",
        "vbox",
        -- add more tag names as needed...
    },

    -- Autostart applications
    autostart_apps = {
        "picom &",
    },


}
