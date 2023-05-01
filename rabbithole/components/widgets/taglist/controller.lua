local __                      = require("lodash")
local awful                   = require("awful")
local wibox                   = require("wibox")
local get_update_function     = require("rabbithole.components.widgets.taglist.update_function")
local taglistButtons          = require("rabbithole.components.widgets.taglist.taglist_buttons")
local local_taglist_template  = require("rabbithole.components.widgets.taglist.template_local")
local global_taglist_template = require("rabbithole.components.widgets.taglist.template_global")
local beautiful               = require("beautiful")
local common                  = require("awful.widget.common")



-- workspace menu controller
local TaglistController = {}
TaglistController.__index = TaglistController

function TaglistController.new(workspaceManagerService, s, tasklist)
    local taglist_menu          = require("rabbithole.components.widgets.taglist.taglistmenu")(
    workspaceManagerService)
    local globaltaglist_menu    = require("rabbithole.components.widgets.taglist.globaltaglistmenu")(
    workspaceManagerService)
    local taglist_buttons       = taglistButtons(taglist_menu, workspaceManagerService)
    local globaltaglist_buttons = taglistButtons(globaltaglist_menu)
    local plusButton            = require("rabbithole.components.widgets.taglist.plus_button")(
    workspaceManagerService)
    -- globe icon for global tag widget
    local icon_path             = awful.util.getdir("config") .. "themes/rabbithole/assets/icons/rabbithole/global.svg"
    local global_icon           = wibox.widget.imagebox(icon_path)

    local self                  = {}
    setmetatable(self, TaglistController)

    -- resources
    self.workspaceManagerService = workspaceManagerService
    self.screen = s
    self.getTasklist = tasklist

    local global_taglist_layout = wibox.layout.fixed.horizontal()

    local global_taglist = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        source          = function()
            return workspaceManagerService:getAllGlobalTags()
        end,
        buttons         = globaltaglist_buttons,
        update_function = get_update_function(s),
        widget_template = global_taglist_template(self)
    }

    global_taglist_layout:add(global_icon)
    global_taglist_layout:add(global_taglist)

    self.my_global_workspace_taglist = global_taglist_layout

    self.my_local_workspace_taglist = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        buttons         = taglist_buttons,
        source          = function() return workspaceManagerService:getAllActiveTags() end,
        update_function = get_update_function(s),
        widget_template = local_taglist_template(self)
    }

    self.taglist_layout = wibox.layout {
        layout = wibox.layout.fixed.horizontal,
        self.my_global_workspace_taglist,
        wibox.widget.separator({
            orientation = 'vertical',
            forced_width = 4,
            opacity = 0.5,
            widget = wibox.widget.separator
        }),
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
        icon_container.widget:add(self.getTasklist(self.screen, tag))
    end
end

-- update index
function TaglistController:update_index(tag_template, index)
    local index_widget = __.first(tag_template:get_children_by_id('index_role')) or nil
    if index_widget then
        index_widget.markup = '<b> ' .. index .. ' </b>'
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
    tag_template:get_children_by_id('text_role')[1]:connect_signal('widget::redraw_needed', function(w)
        local t = tag
        t.name = w.text
    end)
end

function TaglistController:update_tag_callback(tag_template, tag, index, objects)
    self:update_index(tag_template, index)
    -- self:add_client_bubbles(tag_template, tag)
    tag_template.bg = self:set_tag_template_bg(tag)
end

return setmetatable(TaglistController, {
    __call = function(self, workspaceManagerService, s, tasklist)
        return self.new(workspaceManagerService, s, tasklist)
    end
})
