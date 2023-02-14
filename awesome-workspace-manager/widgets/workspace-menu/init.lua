local controller = require("awesome-workspace-manager/widgets/workspace-menu/controller")

local _M = {}

function _M.get(workspaceManagerService)
    return controller(workspaceManagerService):get_view_widget()
end

return setmetatable({}, { __call = function(_, workspaceManagerService) return _M.get(workspaceManagerService) end })