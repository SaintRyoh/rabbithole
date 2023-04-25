local awful = require("awful")
local model = require("awesome-workspace-manager.widgets.tasklist.model")
local view = require("awesome-workspace-manager.widgets.tasklist.view")
local controller = require("awesome-workspace-manager.widgets.tasklist.controller")

local _M = {}

function _M.create(screen)
    local clients = model.get_clients(screen)
    local tasklist_buttons = controller.create_buttons()
    local tasklist_widget = view.create(tasklist_buttons)
    
    return tasklist_widget
end

return _M
