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
    local wm = workspaceManager:new()
    local workspace = wm:createWorkspace()
    wm:switchTo(workspace)


    return wm
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })