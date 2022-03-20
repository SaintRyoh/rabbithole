-- Standard awesome library
local awful = require("awful")
local sharedtags = require("awesome-sharedtags")
local workspaceManager = require("awesome-workspace-manager")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get ()


    local tags1 = sharedtags({
        { name = "tag in workspace1", layout = awful.layout.layouts[2] },
        { name = "movies", layout = awful.layout.layouts[10] },
    })

    local tags2 = sharedtags({
        { name = "tag in workspace2", layout = awful.layout.layouts[2] },
        { name = "music", layout = awful.layout.layouts[10] },
    })

    --__.forEach(tags1, function(o)  o.activated = false end)
    --__.forEach(tags2, function(o)  o.activated = false end)

    wm = workspaceManager:new()

    wm:createWorkspace('workspace_1', tags1)
    wm:createWorkspace('workspace_2', tags2)
    --wm:switchTo(1)

    return nil
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })