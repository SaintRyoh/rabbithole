local __ = require("lodash")
local awful = require("awful")
local wibox = require("wibox")
local get_update_function = require("awesome-workspace-manager.widgets.taglist.update_function")
local taglistButtons   = require("awesome-workspace-manager.widgets.taglist.taglist_buttons")
local taglist_template = require("awesome-workspace-manager.widgets.taglist.template")
local beautiful = require("beautiful")

local _M = {}

-- workspace menu controller
local TaglistController = { }
TaglistController.__index = TaglistController

function TaglistController:new(workspaceManagerService, s)
    local taglist_menu = require("awesome-workspace-manager.widgets.taglist.taglistmenu")(workspaceManagerService)
    local globaltaglist_menu = require("awesome-workspace-manager.widgets.taglist.globaltaglistmenu")(workspaceManagerService)
    local taglist_buttons  = taglistButtons( taglist_menu)
    local globaltaglist_buttons = taglistButtons( globaltaglist_menu)

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
        update_function = get_update_function(s),
        widget_template = taglist_template(self)
    }


    self.my_local_workspace_taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        source = function() return workspaceManagerService:getAllActiveTags() end,
        update_function = get_update_function(s),
        widget_template = taglist_template(self)
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


function TaglistController:create_tag_callback(tag_template, tag, index, objects) --luacheck: no unused args
    tag_template:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
    tag_template.bg = beautiful.bg_focus
    tag_template:connect_signal('mouse::enter', function()
        tag_template.bg = '#ff0000'
    end)
    tag_template:connect_signal('mouse::leave', function()
        if tag.selected then
            tag_template.bg = beautiful.bg_focus
        else
            tag_template.bg = beautiful.bg_normal
        end
    end)
end

function TaglistController:update_tag_callback(tag_template, tag, index, objects)
    tag_template:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
    if tag.selected then
        tag_template.bg = beautiful.bg_focus
    else
        tag_template.bg = beautiful.bg_normal
    end
end

function _M.get(workspaceManagerService, s)
    return TaglistController:new(workspaceManagerService, s)
end

return setmetatable({}, { __call = function(_, workspaceManagerService, s) return _M.get(workspaceManagerService, s) end })
