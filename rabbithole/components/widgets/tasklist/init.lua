local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local view = require("rabbithole.components.widgets.tasklist.view")
local TaskListController = {}
TaskListController.__index = TaskListController

function TaskListController.new(
    rabbithole__components__buttons__tasklist,
    rabbithole__services__animation
)
    local self = setmetatable({}, TaskListController)
    self.tasklist_buttons = rabbithole__components__buttons__tasklist
    self.animationService = rabbithole__services__animation

    -- still need screen and tag before we can create the view so we return a function
    return function (screen, tag)
        self.screen = screen
        self.tag = tag
        return view(self)
    end
end
function TaskListController:get_client_icon(c)
    local icon = c.icon or c.class_icon or c.instance_icon or nil
    if not icon then
    --   icon = gears.surface.load(beautiful.fallback_icon)
        icon = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "themes/rabbithole/icons/fallback.svg")
    end
    return icon
  end

function TaskListController:create_callback(task_template, c, _, _)
    task_template:get_children_by_id('icon_role')[1].image = self:get_client_icon(c)
    local background = task_template:get_children_by_id('background_role')[1]
    local animation = self.animationService:get_basic_animation({
        duration = 0.4,
        rapid_set = true,
        pos = c == client.focus and 1 or 0,
        subscribed = (function (pos)
            background.bg = self.animationService.create_widget_bg(
                self.animationService.blend_colors(beautiful.tasklist_bg_normal, "#e86689", pos), 
                self.animationService.blend_colors(beautiful.tasklist_bg_normal, "#e6537a", pos)
            )
        end)
    })


    task_template:connect_signal('mouse::enter', function()
        animation.target = 1
    end)

    task_template:connect_signal('mouse::leave', function()
        if c ~= client.focus then 
            animation.target = 0
        end

        return true
    end)

    task_template:connect_signal('button::press', function()
        animation.target = 0
        return true
    end)

    task_template:connect_signal('button::release', function()
        animation.target = 1
    end)

    awful.tooltip({
        objects = { task_template },
        timer_function = function()
            return c.name
        end,
    })

end

return TaskListController
