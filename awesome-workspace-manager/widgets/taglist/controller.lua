local __ = require("lodash")
local awful = require("awful")
local wibox = require("wibox")
local get_update_function = require("awesome-workspace-manager.widgets.taglist.update_function")
local taglistButtons   = require("awesome-workspace-manager.widgets.taglist.taglist_buttons")
local local_taglist_template = require("awesome-workspace-manager.widgets.taglist.template_local")
local global_taglist_template = require("awesome-workspace-manager.widgets.taglist.template_global")
local beautiful = require("beautiful")
local common = require("awful.widget.common")


-- workspace menu controller
local TaglistController = { }
TaglistController.__index = TaglistController

function TaglistController.new(workspaceManagerService, s)
    local taglist_menu = require("awesome-workspace-manager.widgets.taglist.taglistmenu")(workspaceManagerService)
    local globaltaglist_menu = require("awesome-workspace-manager.widgets.taglist.globaltaglistmenu")(workspaceManagerService)
    local taglist_buttons  = taglistButtons( taglist_menu)
    local globaltaglist_buttons = taglistButtons( globaltaglist_menu)
    local plusButton = require("awesome-workspace-manager.widgets.taglist.plus_button")(workspaceManagerService)

    local self = {}
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
        widget_template = global_taglist_template(self)
    }


    self.my_local_workspace_taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        source = function() return workspaceManagerService:getAllActiveTags() end,
        update_function = get_update_function(s),
        widget_template = local_taglist_template(self)
    }

    self.taglist_layout = wibox.layout {
        layout = wibox.layout.fixed.horizontal,
        self.my_global_workspace_taglist,
        self.my_local_workspace_taglist,
        plusButton
    }

    return self
end

-- get view 
function TaglistController:get_view_widget()
    return self.taglist_layout
end

-- set tag background color
function TaglistController:set_tag_template_bg(tag)
    if tag.selected then
        return beautiful.taglist_bg_focus
    else
        return beautiful.taglist_bg_normal
    end
end

function TaglistController:add_client_bubbles(tag_template, tag)
    local icon_container = __.first(tag_template:get_children_by_id('icon_container')) or nil
    if icon_container then
        local icons = __.map(tag:clients(), function(client)
            local dpi = require("beautiful").xresources.apply_dpi
            local icon = wibox.widget {
                {
                    id = "icon_container",
                    {
                        id = "icon",
                        resize = true,
                        widget = wibox.widget.imagebox
                    },
                    widget = wibox.container.place
                },
                forced_width = dpi(20),
                margins = dpi(2),
                widget = wibox.container.margin
            }
            icon.icon_container.icon:set_image(client.icon)
            return icon
        end)
        icon_container.widget:set_children(icons)
    end
end

-- update index 
function TaglistController:update_index(tag_template, index)
    local index_widget = __.first(tag_template:get_children_by_id('index_role')) or nil
    if index_widget then 
        index_widget.markup = '<b> '..index..' </b>'
    end
end

function TaglistController:create_tag_callback(tag_template, tag, index, objects) --luacheck: no unused args
    self:update_index(tag_template, index)
    self:add_client_bubbles(tag_template, tag)
    tag_template:connect_signal('mouse::enter', function()
        tag_template.bg = beautiful.taglist_bg_focus
    end)
    tag_template:connect_signal('mouse::leave', function()
        tag_template.bg = self:set_tag_template_bg(tag)
    end)
end

function TaglistController:update_tag_callback(tag_template, tag, index, objects)
    self:update_index(tag_template, index)
    self:add_client_bubbles(tag_template, tag)
    tag_template.bg = self:set_tag_template_bg(tag)
end

return setmetatable(TaglistController, {
    __call = function(self, workspaceManagerService, s)
        return self.new(workspaceManagerService, s)
    end
})