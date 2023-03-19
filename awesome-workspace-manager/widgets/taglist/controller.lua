local __ = require("lodash")
local awful = require("awful")
local template = require("awesome-workspace-manager.widgets.taglist.template")
local wibox = require("wibox")
local get_update_function = require("awesome-workspace-manager.widgets.taglist.update_function")

-- Custom Local Library: Common Functional Decoration
local taglist   = require("awesome-workspace-manager.widgets.taglist.taglist_buttons")

local taglist_buttons  = taglist(require("awesome-workspace-manager.widgets.taglist.taglistmenu"))
local globaltaglist_buttons = taglist(require("awesome-workspace-manager.widgets.taglist.globaltaglistmenu"))
local _M = {}

-- workspace menu controller
local TaglistController = { }
TaglistController.__index = TaglistController

function TaglistController:new(workspaceManagerService, s)
    self = {}
    setmetatable(self, TaglistController)

    -- resources
    self.workspaceManagerService = workspaceManagerService
    self.screen = s
    
    self.my_global_workspace_taglist = awful.widget.taglist {
        screen = s,
        filter  = awful.widget.taglist.filter.all,
        source  = function ()
            return workspaceManagerService:getAllGlobalTags()
        end,
        buttons = globaltaglist_buttons,
        update_function = get_update_function(s)
    }


    self.my_local_workspace_taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        source = function() return workspaceManagerService:getAllActiveTags() end,
        update_function = get_update_function(s)
    }

    self.taglist_layout = wibox.layout {
        layout = wibox.layout.fixed.horizontal,
        self.my_global_workspace_taglist,
        self.my_local_workspace_taglist
    }

    return self
end

-- get view 
function TaglistController:get_view_widget()
    return self.taglist_layout
end

function _M.get(workspaceManagerService, s)
    return TaglistController:new(workspaceManagerService, s)
end

return setmetatable({}, { __call = function(_, workspaceManagerService, s) return _M.get(workspaceManagerService, s) end })