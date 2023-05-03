local awful = require("awful")
local model = require("rabbithole.components.widgets.tasklist.model")
local view = require("rabbithole.components.widgets.tasklist.view")
local controller = require("rabbithole.components.widgets.tasklist.controller")

local _M = {}

function _M.create(screen, tag, tasklistmenu)
    local clients = model.get_clients(screen)
    local tasklist_buttons = controller.create_buttons(tasklistmenu)
    local tasklist_widget = view.create(tasklist_buttons, screen, tag)
    
    return tasklist_widget
end

return setmetatable({}, {
    __constructor = function(
        rabbithole__components__menus__tasklist
    )
        return function(screen, tag)
            return _M.create(screen, tag, rabbithole__components__menus__tasklist)
        end
    end
})
