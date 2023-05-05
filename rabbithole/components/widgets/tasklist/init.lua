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
    self.tasklist = rabbithole__components__buttons__tasklist
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

function TaskListController:create_callback(tasklist, c, _, _)
    tasklist:get_children_by_id("clienticon")[1].image = self:get_client_icon(c)
    local background = tasklist:get_children_by_id('background_role')[1]

    local animation = self.animationService:get_basic_animation()

    animation:subscribe(function (pos)
        if pos  < 0 then
            return
        end
        if pos ==1 then
            c:emit_signal("request::activate", "mouse_leave", {raise = false})
        end
        if pos ==0 then
            c:emit_signal("request::activate", "mouse_enter", {raise = false})
        end
        background.bg = self.animationService:create_widget_bg(
            self.animationService:blend_colors("#111111", "#e86689", pos * 100), 
            self.animationService:blend_colors("#111111", "#e6537a", pos * 100)
        )
    end)

    tasklist:connect_signal('mouse::enter', function()
        -- for highlighting tag preview

        -- for highlighting tasklist
        -- background.bg = beautiful.bg_focus
        animation.target = 0
    end)

    tasklist:connect_signal('mouse::leave', function()
        -- for highlighting tag preview
        if c == client.focus then return end

        -- for highlighting tasklist
        -- background.bg = "#00000000"
        animation.target = 1

        return true
    end)

    tasklist:connect_signal('button::press', function()
        animation.target = 1
        animation:fire(0, 1)
        return true
    end)

    tasklist:connect_signal('button::release', function()
        animation.target = 0
        animation:fire(1, 1)
        return true
    end)

    awful.tooltip({
        objects = { tasklist },
        timer_function = function()
            return c.name
        end,
    })

end

return TaskListController
