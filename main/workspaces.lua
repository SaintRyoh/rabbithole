-- Standard awesome library
local awful = require("awful")
local sharedtags = require("awesome-sharedtags")
local workspaceManager = require("awesome-workspace-manager")

local naughty = require("naughty")
local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get ()
    naughty.notify({

        title="making a workspace manager",
        text=string.format("screen count: %d ", screen.count()),
        timeout=0
    })
    wm = workspaceManager:new()
    workspace_id_1 = wm:createWorkspace()
    wm:switchTo(workspace_id_1)


    return wm
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })