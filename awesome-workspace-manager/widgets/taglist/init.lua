local controller = require("awesome-workspace-manager/widgets/taglist/controller")

local _M = {}

function _M.get(workspaceManagerService, s)
    return controller(workspaceManagerService, s):get_view_widget()
end

return setmetatable({}, { __call = function(_, workspaceManagerService, s) return _M.get(workspaceManagerService, s) end })