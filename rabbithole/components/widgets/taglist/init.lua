local __                      = require("lodash")
local awful                   = require("awful")
local wibox                   = require("wibox")
local get_update_function     = require("rabbithole.components.widgets.taglist.update_function")
local local_taglist_template  = require("rabbithole.components.widgets.taglist.template_local")
local global_taglist_template = require("rabbithole.components.widgets.taglist.template_global")
local beautiful               = require("beautiful")
local gears                  = require("gears")


-- workspace menu controller
local TaglistController = {}
TaglistController.__index = TaglistController

function TaglistController.new(
    workspaceManagerService,
    rabbithole__components__widgets__tasklist,
    rabbithole__services__tag___preview,
    rabbithole__services__animation,
    rabbithole__components__buttons__taglist,
    rabbithole__components__buttons__global___taglist
)
    local plusButton            = require("rabbithole.components.widgets.taglist.plus_button")(workspaceManagerService)
    -- globe icon for global tag widget
    local icon_path             = awful.util.getdir("config") .. "themes/rabbithole/assets/icons/rabbithole/global.svg"
    local global_icon           = wibox.widget.imagebox(icon_path)

    local self                  = {}
    setmetatable(self, TaglistController)
    -- resources
    self.workspaceManagerService = workspaceManagerService
    self.getTasklist = rabbithole__components__widgets__tasklist
    self.tagPreview = rabbithole__services__tag___preview
    self.animationService = rabbithole__services__animation

    return function (s)
        self.screen = s


        local global_taglist = awful.widget.taglist {
            screen          = s,
            filter          = awful.widget.taglist.filter.all,
            source          = function()
                return workspaceManagerService:getAllGlobalTags()
            end,
            buttons         = rabbithole__components__buttons__global___taglist,
            update_function = get_update_function(s),
            widget_template = global_taglist_template(self)
        }



        local my_local_workspace_taglist = awful.widget.taglist {
            screen          = s,
            filter          = awful.widget.taglist.filter.all,
            buttons         = rabbithole__components__buttons__taglist,
            source          = function() return workspaceManagerService:getAllActiveTags() end,
            update_function = get_update_function(s),
            widget_template = local_taglist_template(self)
        }

        self.taglist_layout = wibox.layout {
            layout = wibox.layout.fixed.horizontal,
            global_icon,
            global_taglist,
            wibox.widget.separator({
                orientation = 'vertical',
                forced_width = 4,
                opacity = 0.5,
                widget = wibox.widget.separator
            }),
            my_local_workspace_taglist,
            plusButton
        }

        return self.taglist_layout
    end

end

function TaglistController:add_client_bubbles(tag_template, tag)
    local icon_container = __.first(tag_template:get_children_by_id('icon_container')) or nil
    if icon_container then
        icon_container.widget:add(self.getTasklist(self.screen, tag))
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
    
    tag_template:connect_signal('mouse::enter', function()
        hover_timer:again()
        animation.target = 0
    end)

    tag_template:connect_signal('mouse::leave', function()
        -- tag preview
        hover_timer:stop()
        self.tagPreview.hide(self.screen)

        --animation
        if not tag.selected then
            animation.target = 1
        end

    end)

    tag_template:connect_signal('button::press', function()
        animation.target = 1
        animation:fire(0, 1)
    end)

    tag_template:connect_signal('button::release', function()
        animation.target = 0
        animation:fire(1, 1)
    end)
end

-- update index
function TaglistController:update_index(tag_template, index)
    local index_widget = __.first(tag_template:get_children_by_id('index_role')) or nil
    if index_widget then
        index_widget.markup = '<b> ' .. index .. ' </b>'
    end
end

function TaglistController:update_tag_callback(tag_template, tag, index, objects)
    self:update_index(tag_template, index)
end

return TaglistController
