local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local view = require("rabbithole.components.widgets.tasklist.view")
local TaskListController = {}
TaskListController.__index = TaskListController

function TaskListController.new(
    rabbithole__components__buttons__tasklist,
    rabbithole__services__animation,
    rabbithole__services__color,
    rabbithole__services__icon___handler
)
    local self = setmetatable({}, TaskListController)
    self.tasklist_buttons = rabbithole__components__buttons__tasklist
    self.animation = rabbithole__services__animation
    self.color = rabbithole__services__color
    self.icon = rabbithole__services__icon___handler

    -- still need screen and tag before we can create the view so we return a function
    return function (screen, tag)
        self.screen = screen
        self.tag = tag
        local status, ret = pcall(view, self)
        if status then
            return ret
        else
            self.screen = awful.screen.focused()
            return view(self)
        end
    end
end

function TaskListController:create_callback(task_template, c, _, _)
    task_template:get_children_by_id('icon_role')[1].image = self.icon:get_icon_by_client(c)
    local background = task_template:get_children_by_id('background_role')[1]

    local animation = self.animation({
        duration = 0.4,
        rapid_set = true,
        pos = c == client.focus and 1 or 0,
        subscribed = (function (pos)
            background.bg = self.color.twoColorGradient3d(
                self.color.blend_colors(beautiful.tasklist_bg_normal, beautiful.tertiary_1, pos),
                self.color.blend_colors(beautiful.tasklist_bg_normal, beautiful.tertiary_2, pos)
            )
        end)
    })


    task_template:connect_signal('mouse::enter', function()
        animation.target = 1
        c:emit_signal('request::activate', 'mouse_enter', {raise = false})
    end)

    task_template:connect_signal('mouse::leave', function()
        c:emit_signal('request::activate', 'mouse_leave', {raise = false})
        if c ~= client.focus then 
            animation.target = 0
        end

        return true
    end)

    task_template:connect_signal('button::press', function()
        animation.target = 0
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
