local __                      = require("lodash")
local awful                   = require("awful")
local wibox                   = require("wibox")
local get_update_function     = require("rabbithole.components.widgets.taglist.update_function")
local local_taglist_template  = require("rabbithole.components.widgets.taglist.template_local")
local global_taglist_template = require("rabbithole.components.widgets.taglist.template_global")
local gears                  = require("gears")
local beautiful             = require("beautiful")
local math                  = require("math")


-- workspace menu controller
local TaglistController = {}
TaglistController.__index = TaglistController

function TaglistController.new(
    workspaceManagerService,
    rabbithole__components__widgets__tasklist,
    rabbithole__services__tag___preview,
    rabbithole__services__animation,
    rabbithole__services__color,
    rabbithole__components__buttons__taglist,
    rabbithole__components__buttons__taglist___global
)
    local plusButton            = require("rabbithole.components.widgets.taglist.plus_button")(workspaceManagerService)
    -- globe icon for global tag widget
    local icon_path             = awful.util.getdir("config") .. "themes/rabbithole/icons/rabbithole/global.svg"
    local global_icon           = wibox.widget.imagebox(icon_path)
    global_icon:connect_signal("button::press", function(_, _, _, button)
        if button == 3 then
            local tag = awful.tag.add("Global")
            workspaceManagerService:getGlobalWorkspace():addTag(tag)
        end
    end)

    local self                  = {}
    setmetatable(self, TaglistController)
    -- resources
    self.workspaceManagerService = workspaceManagerService
    self.getTasklist = rabbithole__components__widgets__tasklist
    self.tagPreview = rabbithole__services__tag___preview
    self.animation = rabbithole__services__animation
    self.color = rabbithole__services__color

    return function (s)
        self.screen = s


        local global_taglist = awful.widget.taglist {
            screen          = s,
            filter          = awful.widget.taglist.filter.all,
            source          = function()
                return workspaceManagerService:getAllGlobalTags()
            end,
            buttons         = rabbithole__components__buttons__taglist___global,
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

        s.taglist_layout = self.taglist_layout

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
        timeout = 1.0,
        autostart = false,
        callback = function()
            self.tagPreview.show(tag, self.screen)
        end
    }

    local animation = self.animation({
        pos = tag.selected and 1 or 0,
        duration = 0.4,
        rapid_set = true,
        subscribed = function (pos)
            if type(tag_template.bg) == "string" then
                tag_template.bg = self.colors.blend_colors(beautiful.bg_normal, beautiful.bg_focus, pos)
            else
                tag_template.bg = self.color.create_widget_bg_3d_2color(
                    self.color.blend_colors(beautiful.base_color, beautiful.tertiary_1, pos), 
                    self.color.blend_colors(beautiful.secondary_color, beautiful.tertiary_2, pos)
                )
            end
        end
    })


    awful.tooltip({
        objects = { tag_template },
        timer_function = function()
            return "Middle click to delete"
        end,
        timeout = 0.5,
        delay_show = 3,
        mode = 'outside',
        preferred_positions = {'bottom'},
        preferred_alignments = {'middle'}


    })
    
    tag_template:connect_signal('mouse::enter', function()
        hover_timer:again()
        animation.target = 1
    end)

    tag_template:connect_signal('mouse::leave', function()
        -- tag preview
        hover_timer:stop()
        self.tagPreview.hide(self.screen)

        --animation
        if not tag.selected or tag.screen ~= awful.screen.focused() then
            animation.target = 0
        end

    end)

    tag_template:connect_signal('button::press', function()
        animation.target = 0
    end)

    tag_template:connect_signal('button::release', function()
        animation.target = 1
    end)
end

-- update index
function TaglistController:update_index(tag_template, index)
    index = math.min(index, 9)
    local index_widget = __.first(tag_template:get_children_by_id('index_role')) or nil
    if index_widget then
        index_widget.markup = '<b> ' .. index .. ' </b>'
    end
end

function TaglistController:update_tag_callback(tag_template, tag, index, objects)
    self:update_index(tag_template, index)
end

return TaglistController
