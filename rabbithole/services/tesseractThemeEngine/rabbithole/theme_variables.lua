--[[
  Main themeing variables file. Everything including custom widgets are edited here.
  Eventually, the goal is the ability to change every single element of the appearance of
  Rabbithole via this file and to have it play nice with the future settings manager. 
--]]
-- Awesome Libs
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local awful = require("awful")

-- Custom local libs
local color = require("src.themes.rabbithole.colors")

-- Titlebar icon directory path
local icondir = awful.util.getdir("config") .. "src/assets/icons/titlebar/"

-- Helper function to create the 3D gradient background for widgets
local create_widget_bg = function(color1, color2)
    return {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(40) },
        stops = {
            { 0, color1 },
            { 0.5, color2 },
            { 1, color1 }
        }
    }
end

-- Helper function to create a widget with softed edges
-- Function to create a widget background gradient with edges in a softer, almost white gradient
local function create_widget_soft(start_color, end_color)
  return function(cr, width, height, x, y, widget)
      local start_x, start_y = x, y
      local end_x, end_y = x + width, y + height
      local pat_top = gears.color.create_linear_pattern({ start_x, start_y }, { start_x, start_y + height/5 }, { end_color, start_color })
      local pat_bottom = gears.color.create_linear_pattern({ start_x, end_y }, { start_x, end_y - height/5 }, { start_color, end_color })
      local pat_left = gears.color.create_linear_pattern({ start_x, start_y }, { start_x + width/5, start_y }, { end_color, start_color })
      local pat_right = gears.color.create_linear_pattern({ end_x, start_y }, { end_x - width/5, start_y }, { start_color, end_color })
      local pat_center = gears.color.create_linear_pattern({ start_x, start_y + height/5 }, { start_x, end_y - height/5 }, { start_color, start_color })

      gears.shape.rectangle(cr, width, height)

      cr:set_source(pat_top)
      cr:rectangle(start_x, start_y, width, height/5)
      cr:fill()

      cr:set_source(pat_bottom)
      cr:rectangle(start_x, end_y - height/5, width, height/5)
      cr:fill()

      cr:set_source(pat_left)
      cr:rectangle(start_x, start_y, width/5, height)
      cr:fill()

      cr:set_source(pat_right)
      cr:rectangle(end_x - width/5, start_y, width/5, height)
      cr:fill()

      cr:set_source(pat_center)
      cr:rectangle(start_x + width/5, start_y + height/5, width*3/5, height*3/5)
      cr:fill()
  end
end


-- Helper function to create the shadow for widgets
local create_widget_shadow = function(radius, offset)
    return {
        offset = offset,
        color = "#000000",
        opacity = 1.4,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, radius)
        end
    }
end

Theme.useless_gap = dpi(5) -- Change this to 0 if you dont like window gaps
Theme.border_width = dpi(0) -- Change this to 0 if you dont like borders

Theme.font = user_vars.font.bold

Theme.bg_normal = create_widget_bg(color["DeepPurple800"], color["DeepPurple600"]) -- titlebar unfocused bg
Theme.bg_focus = create_widget_bg(color["DeepPurple500"], color["DeepPurple100"]) -- titlebar focused bg
Theme.bg_urgent = color["LightPurple800"]
Theme.bg_minimize = color["White"]
Theme.bg_systray = color["White"]

Theme.fg_normal = color["White"]
Theme.fg_focus = color["White"]
Theme.fg_urgent = color["White"]
Theme.fg_minimize = color["White"]

Theme.border_normal = color["Grey800"]
Theme.border_marked = color["LightPurple400"]

Theme.menu_bg_normal = color["DarkPurple400"]
Theme.menu_bg_focus = color["Grey900"]
Theme.menu_fg_focus = color["White"]
Theme.menu_border_color = color["DarkPurple200"]

Theme.taglist_fg_focus = color["Grey900"]
Theme.taglist_bg_focus = color["DarkPurple400"]

Theme.tooltip_border_color = color["Grey800"]
Theme.tooltip_bg = color["Grey900"]
Theme.tooltip_fg = color["LightPurple200"]
Theme.tooltip_border_width = dpi(4)
Theme.tooltip_gaps = dpi(15)
Theme.tooltip_shape = function(cr, width, heigth)
  gears.shape.rounded_rect(cr, width, heigth, 5)
end

Theme.notification_spacing = dpi(20)

-- [[[ -- Custom theme elements exclusive to rabbithole
local workspacemenu_icons_path = "../../assets/icons/workspace_menu/"
Theme.workspacemenu_bg = create_widget_bg(color["DeepPurple900"], color["DeepPurple400"]) -- Updated color
Theme.workspacemenu_font = "Ubuntu 10"
Theme.workspacemenu_icons = {
    ["default"] = gears.surface.load(workspacemenu_icons_path .. "workspace_menu.svg"),
    ["internet"] = gears.surface.load("/path/to/internet/icon.png"),
    ["work"] = gears.surface.load("/path/to/work/icon.png"),
    ["coding"] = gears.surface.load("/path/to/coding/icon.png"),
    -- add more workspace names and icon paths as needed
}
Theme.workspacemenu_border_color = color["Black"]
--Bunnybar elements
Theme.left_bar_color = create_widget_bg(color["LightBlue200"], color["DeepPurpleA700"])
Theme.center_bar_color = "transparent"
Theme.right_bar_color = "transparent"
-- Taglist widget elements
-- Tasklist widget elements
Theme.tasklist_bg = color["LightBlue200"] 
Theme.tasklist_fg = color["Grey900"] -- font color
-- ]]]

-- Create the 3D gradient and shadow for widgets
Theme.widget_bg_gradient = create_widget_bg(color["Grey900"], color["Grey600"])
Theme.widget_shadow = create_widget_shadow(dpi(5), { x = dpi(0), y = dpi(2) })

Theme.titlebar_close_button_normal = icondir .. "close.svg"
Theme.titlebar_maximized_button_normal = icondir .. "maximize.svg"
Theme.titlebar_minimize_button_normal = icondir .. "minimize.svg"
Theme.titlebar_maximized_button_active = icondir .. "maximize.svg"
Theme.titlebar_maximized_button_inactive = icondir .. "maximize.svg"

Theme.bg_systray = color["BlueGrey800"]
Theme.systray_icon_spacing = dpi(10)

Theme.hotkeys_bg = color["Grey900"]
Theme.hotkeys_fg = color["White"]
Theme.hotkeys_border_width = 0
Theme.hotkeys_shape = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, 10)
end
Theme.hotkeys_description_font = user_vars.font.bold

-- layout icon directory path
local layout_path = icondir  .. "../../assets/layout/"

-- Here are the icons for the layouts defined, if you want to add more layouts go to main/layouts.lua
Theme.layout_floating = layout_path .. "floating.svg"
Theme.layout_tile = layout_path .. "tile.svg"
Theme.layout_dwindle = layout_path .. "dwindle.svg"
Theme.layout_fairh = layout_path .. "fairh.svg"
Theme.layout_fairv = layout_path .. "fairv.svg"
Theme.layout_fullscreen = layout_path .. "fullscreen.svg"
Theme.layout_max = layout_path .. "max.svg"
Theme.layout_cornerne = layout_path .. "cornerne.svg"
Theme.layout_cornernw = layout_path .. "cornernw.svg"
Theme.layout_cornerse = layout_path .. "cornerse.svg"
Theme.layout_cornersw = layout_path .. "cornersw.svg"
