-- Bunny_bar - Rabbithole's segmented wibar system

-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")
-- Wibox handling library
local wibox = require("wibox")

local workspaceManagerService = RC.workspaceManagerService

-- Custom Local Library: Common Functional Decoration
local deco = {
    wallpaper = require("deco.wallpaper"),
}

local workspaceMenu = require("awesome-workspace-manager.widgets.workspace-menu")
local taglist = require("awesome-workspace-manager.widgets.taglist")

local tasklist_buttons = require("deco.tasklist_buttons")()

local __ = require("lodash")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    --     end

    -- if workspaceManagerService.session_restored ~= true then
    workspaceManagerService:assignWorkspaceTagsToScreens()
    --     workspaceManagerService.session_restored = true
    -- end

    require("src.modules.powermenu")(s)
    -- TODO: rewrite calendar osd, maybe write an own inplementation
    -- require("src.modules.calendar_osd")(s)
    require("src.modules.volume_osd")(s)
    require("src.modules.brightness_osd")(s)
    require("src.modules.titlebar")
    --require("src.modules.volume_controller")(s)
  
    -- Widgets definitions
    --s.battery = require("src.widgets.battery")()
    --s.audio = require("src.widgets.audio")(s)
    s.date = require("src.widgets.date")()
    s.clock = require("src.widgets.clock")()
    s.bluetooth = require("src.widgets.bluetooth")()
    s.layoutlist = require("src.widgets.layout_list")(s)
    s.powerbutton = require("src.widgets.power")()
    --s.kblayout = require("src.widgets.kblayout")(s)
    s.taglist = require("src.widgets.taglist")(s)
    s.tasklist = require("src.widgets.tasklist")(s)
    --s.cpu_freq = require("src.widgets.cpu_info")("freq", "average")
  
    -- Add more of these if statements if you want to change
    -- the modules/widgets per screen.
    if s.index == 1 then
        s.systray = require("src.widgets.systray")(s)
       -- s.cpu_usage = require("src.widgets.cpu_info")("usage")
       -- s.cpu_temp = require("src.widgets.cpu_info")("temp")
       -- s.gpu_usage = require("src.widgets.gpu_info")("usage")
       -- s.gpu_temp = require("src.widgets.gpu_info")("temp")
       -- s.network = require("src.widgets.network")()
    
        require("bunny_bar.left_bar")(s, { workspaceMenu(workspaceManagerService), s.taglist }) --taglist(workspaceManagerService, s)
        require("bunny_bar.center_bar")(s, { s.tasklist, s.layoutlist })
        require("bunny_bar.right_bar")(s, { s.date, s.clock, s.systray, s.powerbutton })
        --require("bunny_bar.dock")(s, user_vars.dock_programs)
    end
end)
