local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local TaskListController = {}
TaskListController.__index = TaskListController

function TaskListController.new(
    rabbithole__components__buttons__tasklist
)
    local self = setmetatable({}, TaskListController)
    return function (screen, tag)
        return require("rabbithole.components.widgets.tasklist.view")(
            self, 
            rabbithole__components__buttons__tasklist, 
            screen, 
            tag
        )
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

    local timer = gears.timer {
        timeout = 0.5,
        autostart = true,
        single_shot = true,
        callback = function()
            c:emit_signal("request::activate", "mouse_enter", {raise = false})
        end
    }

    tasklist:connect_signal('mouse::enter', function()
        tasklist:get_children_by_id('background_role')[1]:set_bg(beautiful.bg_focus)
        tasklist:get_children_by_id('background_role')[1]:set_fg(beautiful.bg_focus)
        timer:again()
    end)
    tasklist:connect_signal('mouse::leave', function()
        if timer.started then 
            timer:stop() 
        else
            c:emit_signal("request::activate", "mouse_leave", {raise = false})
        end
        if c == client.focus then return end
        tasklist:get_children_by_id('background_role')[1]:set_bg('#00000000')
        tasklist:get_children_by_id('background_role')[1]:set_fg('#00000000')

    end)

    awful.tooltip({
        objects = { tasklist },
        timer_function = function()
            return c.name
        end,
    })
end

return TaskListController
