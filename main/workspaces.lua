-- Standard awesome library
local awful = require("awful")
local sharedtags = require("awesome-sharedtags")
local workspaceManager = require("awesome-workspace-manager")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get ()

    wm = workspaceManager:new()
    workspace_id = wm:createWorkspace()
    wm:switchTo(workspace_id)

    return wm
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })