local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xdg_menu = require("archmenu") -- Make sure to install this module

local appDrawer = {}

function appDrawer.new(args)
    local self = {}
    setmetatable(self, { __index = appDrawer })

    self.categories = {
        accessories = "Accessories",
        games = "Games",
        graphics = "Graphics",
        internet = "Internet & Network",
        office = "Office",
        programming = "Programming",
        sound_video = "Sound & Video",
        system = "System Tools",
        other = "Other",
    }

    self.favorites = {
        -- Add your favorite applications in the format {name, icon, command}
        { "Firefox", "firefox", "firefox" },
    }

    self.promptbox = awful.widget.prompt()
    self.menu = self:create_menu()

    return self
end

function appDrawer:create_menu()
    local main_menu = {}
    local categories = xdg_menu.GenerateCategories()

    -- Add favorites
    table.insert(main_menu, { "Favorites", nil, self:create_favorites_menu() })

    -- Add categories
    for _, category in ipairs(categories) do
        if self.categories[category.name] then
            local menu_entries = xdg_menu.GenerateMenu({ category = category.name })
            if #menu_entries > 0 then
                table.insert(main_menu, { self.categories[category.name], nil, menu_entries })
            end
        end
    end

    local menu = awful.menu({ items = main_menu, width = 300 })

    return menu
end

function appDrawer:create_favorites_menu()
    local menu_entries = {}

    for _, favorite in ipairs(self.favorites) do
        table.insert(menu_entries, { favorite[1], favorite[2], function() awful.spawn(favorite[3]) end })
    end

    return menu_entries
end

function appDrawer:toggle()
    if self.menu.visible then
        self.menu:hide()
    else
        self.menu:show()
        self.promptbox:run(
            { prompt = "Search: " },
            function(...)
                local result = awful.spawn.easy_async_with_shell(
                    "sh -c 'IFS=:; find $PATH -maxdepth 1 -executable -name \"*\"(e)'",
                    function(stdout, stderr, reason, exit_code)
                        if exit_code == 0 then
                            local app_name = nil
                            for line in stdout:gmatch("[^\r\n]+") do
                                if line:match(".*" .. (...) .. ".*") then
                                    app_name = line
                                    break
                                end
                            end
                            if app_name then
                                awful.spawn(app_name)
                            end
                        end
                    end
                )
            end,
            function() self.menu:hide() end
        )
    end
end

return appDrawer
