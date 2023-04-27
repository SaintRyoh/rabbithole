local awful = require("awful")
local model = require("awesome-workspace-manager.widgets.tasklist.model")
local view = require("awesome-workspace-manager.widgets.tasklist.view")
local controller = require("awesome-workspace-manager.widgets.tasklist.controller")

local _M = {}

function _M.create(screen, tag, tasklistmenu)
    local clients = model.get_clients(screen)
    local tasklist_buttons = controller.create_buttons(tasklistmenu)
    local tasklist_widget = view.create(tasklist_buttons, screen, tag)
    
    return tasklist_widget
end

return setmetatable({}, {
    __constructor = function(
        awesome___workspace___manager__menus__tasklistmenu
    )
        return function(screen, tag)
            return _M.create(screen, tag, awesome___workspace___manager__menus__tasklistmenu)
        end
    end
})
