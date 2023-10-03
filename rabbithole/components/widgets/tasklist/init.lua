local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local view = require("rabbithole.components.widgets.tasklist.view")

local TaskListController = {}
TaskListController.__index = TaskListController

function TaskListController.new(
    rabbithole__components__buttons__tasklist,
    rabbithole__services__animation,
    rabbithole__services__color,
    rabbithole__services__icon___handler,
    dragondrop
)
    local self = setmetatable({ }, TaskListController)

    self.tasklist_buttons = rabbithole__components__buttons__tasklist
    self.animation = rabbithole__services__animation
    self.color = rabbithole__services__color
    self.icon = rabbithole__services__icon___handler
    self.dragndrop = dragondrop
    self.client = nil
    self.hovered_tag = nil

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
    local background = task_template:get_children_by_id('background_role')[1]
    task_template:get_children_by_id('icon_role')[1].image = self.icon:get_icon_by_client(c)

    local animation = self.animation({
        duration = 0.2,  -- Increased the duration slightly for smoother animation
        rapid_set = false,  -- Setting this to false might make the animation smoother
        pos = c == client.focus and 1 or 0,
        subscribed = function(pos)
            if pos == 0 then
                background.bg = beautiful.tasklist_bg_normal
            else
                background.bg = self.color.create_widget_bg(
                    self.color.blend_colors(beautiful.base_color, beautiful.tertiary_1, pos),
                    self.color.blend_colors(beautiful.secondary_color, beautiful.tertiary_2, pos)
                )
            end
        end
    })

    task_template:connect_signal('mouse::enter', function()
        animation.target = 1
        c:emit_signal('request::activate', 'mouse_enter', {raise = false})
    end)

    task_template:connect_signal('mouse::leave', function()
        if c ~= client.focus then 
            animation.target = 0
        else
            background.bg = self.color.create_widget_bg(
                self.color.blend_colors(beautiful.base_color, beautiful.tertiary_1, 1),
                self.color.blend_colors(beautiful.secondary_color, beautiful.tertiary_2, 1)
            )
        end
        return true
    end)

    local client = c -- Create a closure

    task_template:connect_signal('button::press', function(_, _, _, button)
        if button == 2 then  -- middle mouse button click kills clients, so return and do nothing
            return
        end

        animation.target = 0
        -- dragondrop logic
        self.client = client
        self.origin_tag = awful.screen.focused().selected_tag
        self.dragndrop:drag(self.client, self.origin_tag)
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
