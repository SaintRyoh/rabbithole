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
    rabbithole__services__dragondrop
)
    local self = setmetatable({ }, TaskListController)

    self.tasklist_buttons = rabbithole__components__buttons__tasklist
    self.animation = rabbithole__services__animation
    self.color = rabbithole__services__color
    self.icon = rabbithole__services__icon___handler
    self.dragndrop = rabbithole__services__dragondrop
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
    task_template:get_children_by_id('icon_role')[1].image = self.icon:get_icon_by_client(c)
    local background = task_template:get_children_by_id('background_role')[1]

    local animation = self.animation({
        duration = 0.2,
        rapid_set = true,
        pos = c == client.focus and 1 or 0,
        subscribed = (function (pos)
            if pos == 0 then
                background.bg = beautiful.tasklist_bg_normal
            else
                background.bg = self.color.create_widget_bg(
                    self.color.blend_colors(beautiful.tasklist_bg_normal, beautiful.tertiary_1, pos),
                    self.color.blend_colors(beautiful.tasklist_bg_normal, beautiful.tertiary_1, pos)
                )
            end
        end)
    })

    --self.client = c -- Create a closure

    task_template:connect_signal('mouse::enter', function()
        animation.target = 1
        c:emit_signal('request::activate', 'mouse_enter', {raise = false})
    end)

    task_template:connect_signal('mouse::leave', function()
        c:emit_signal('request::activate', 'mouse_leave', {raise = false})
        gears.timer.start_new(0.1, function()
            if c ~= client.focus then 
                animation.target = 0
            end
        end)
        return true
    end)

    local client = c -- Create a closure
    task_template:connect_signal('button::press', function()
        animation.target = 0
        -- Drag and drop tests
        print("INSIDE TASKLIST BUTTON::PRESS\nMouse button held down.\nOrigin tag printed below:")
        print(awful.screen.focused().selected_tag)
        print("Printing origin client from tasklist:")
        print(client)
        self.client = client
        self.origin_tag = awful.screen.focused().selected_tag
        self.dragndrop:drag(self.client, self.origin_tag)  -- Start dragging the client
    end)

    task_template:connect_signal('button::release', function()
        print("INSIDE TASKLIST BUTTON::RELEASE\nReleasing mouse...\nPrinting dragndrop.client and awful.screen.focused().selected_tag...")
        print(self.dragndrop.client)
        print(awful.screen.focused().selected_tag)
        self.client = self.dragndrop.client
        self.hovered_tag = awful.screen.focused().selected_tag
        print(self.hovered_tag)
        self.dragndrop:drop(self.client, self.hovered_tag)  -- Drop the client on the currently selected tag
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

