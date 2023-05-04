local __                      = require("lodash")
local awful                   = require("awful")
local wibox                   = require("wibox")
local get_update_function     = require("rabbithole.components.widgets.taglist.update_function")
local taglistButtons          = require("rabbithole.components.widgets.taglist.taglist_buttons")
local local_taglist_template  = require("rabbithole.components.widgets.taglist.template_local")
local global_taglist_template = require("rabbithole.components.widgets.taglist.template_global")
local beautiful               = require("beautiful")
local common                  = require("awful.widget.common")
local gears                  = require("gears")
local colorHelper = require("sub/bling/helpers/color")


-- workspace menu controller
local TaglistController = {}
TaglistController.__index = TaglistController

function TaglistController.new(workspaceManagerService, s, tasklist, tagPreview, animationService)
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
    self.tagPreview = tagPreview
    self.animationService = animationService

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
    if tag.selected and tag.screen == self.screen then
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
    local hover_timer = gears.timer {
        timeout = 0.5,
        autostart = false,
        callback = function()
            self.tagPreview.show(tag, self.screen)
        end
    }
    local animation = self.animationService:get_basic_animation()
    animation:subscribe(function (pos)
        tag_template.bg = self.animationService:create_widget_bg(
            self.animationService:blend_colors("#5123db", "#e86689", pos * 100), 
            self.animationService:blend_colors("#6e5bd6", "#e6537a", pos * 100)
        )
    end)
    -- animation.target = 1
    tag_template:connect_signal('mouse::enter', function()
        hover_timer:again()
        local cl = self.animationService:create_widget_bg(
            self.animationService:blend_colors("#5123db", "#e86689", 1 * 100), 
            self.animationService:blend_colors("#6e5bd6", "#e6537a", 1 * 100)
        )
        if tag_template.bg ~= cl then
            animation.target = 0
        end
    end)
    tag_template:connect_signal('mouse::leave', function()
        hover_timer:stop()
        self.tagPreview.hide(self.screen)
        local cl = self.animationService:create_widget_bg(
            self.animationService:blend_colors("#5123db", "#e86689", 0 * 100), 
            self.animationService:blend_colors("#6e5bd6", "#e6537a", 0 * 100)
        )
        if tag_template.bg ~= cl and not tag.selected then
            animation.target = 1
        end
    end)
    tag_template:connect_signal('button::press', function()
        animation.target = 1
        animation:fire(0)
    end)
    tag_template:connect_signal('button::release', function()
        animation.target = 0
        animation:fire(1)
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
    __call = function(self, workspaceManagerService, s, tasklist, tagPreview, animationService)
        return self.new(workspaceManagerService, s, tasklist, tagPreview, animationService)
    end
})
