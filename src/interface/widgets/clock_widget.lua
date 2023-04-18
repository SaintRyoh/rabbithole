local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local function grid_layout(num_columns, menu_items)
    local num_rows = math.ceil(#menu_items / num_columns)
    local layout = {}

    for i = 1, num_rows do
        local row = {}
        for j = 1, num_columns do
            local item = menu_items[(i - 1) * num_columns + j]
            if item then
                table.insert(row, item)
            end
        end
        table.insert(layout, row)
    end

    return layout
end


local function create_clock_widget()
    -- Create the clock widget
    local myclock = wibox.widget.textclock("%a %b %d, %H:%M")

    -- Systray items
    local my_systray_icons = {
        -- Replace "icon1", "icon2", "icon3" with the actual names of your SVG files
        { "workspace_menu.svg", "TestIcon", "../../assets/icons/workspace_menu/workspace_menu.svg" },
        { "workspace_menu.svg", "TestIcon", "../../assets/icons/workspace_menu/workspace_menu.svg" },
        { "workspace_menu.svg", "TestIcon", "../../assets/icons/workspace_menu/workspace_menu.svg" },
        -- Add more items as needed
    }

    -- Create the systray menu
    local my_systray_menu = awful.menu({
        items = grid_layout(3, my_systray_icons),
    })

    -- Animation function for showing the systray menu
    local function show_systray_menu()
        -- Calculate the menu position
        local s = mouse.screen
        local menu_width = 3 * 64 -- Assuming each icon is 64 pixels wide
        local menu_height = my_systray_menu.wibox.height
        local screen_width = s.geometry.width
    
        local x = screen_width - menu_width
        local y = 0 -- Set the Y coordinate to 0 for the top right corner
    
        -- Set the menu position
        my_systray_menu.wibox.x = x
        my_systray_menu.wibox.y = y
        local opacity_step = 0.1
        local animation_duration = 0.3
        local steps = math.floor(animation_duration / opacity_step)
        local current_step = 0

        my_systray_menu.wibox.opacity = 0
        my_systray_menu.wibox.visible = true

        gears.timer.start_new(opacity_step, function()
            current_step = current_step + 1
            my_systray_menu.wibox.opacity = current_step / steps

            if current_step >= steps then
                return false
            end
            return true
        end)
    end

    -- Bind the clock widget to open the dropdown menu
    myclock:buttons(awful.util.table.join(
        awful.button({}, 1, function() show_systray_menu() end)
    ))

    return myclock
end

return create_clock_widget
