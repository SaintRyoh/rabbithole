--- This should allow tags to stay organized when dynamically adding/removing screens
--- The basic idea is that tags aren't workspaces, they are just tags, and workspaces are collections of tags.
-- @module workspaceManager
-- @author Matt Mann
-- @copyright 2022 Matt Mann
-- @license MIT

local lodash = require("lodash")
local workspace = require("workspace")



-- needs to be singleton
local workspaceManager = {}
workspaceManager.__index = workspaceManager

function workspaceManager:new()
    self = {}
    setmetatable(self, workspaceManager)

    self.workspaces = {}

    return self
end

function workspaceManager:createWorkspace(name, tags)
    local new_workspace = workspace:new(name, tags)
    lodash.push(self.workspaces, new_workspace)
    return new_workspace
end

function workspaceManager:deleteWorkspace(workspace)
    workspace:removeAllTagsInWorkspace()
    lodash.remove(self.workspaces, function(_workspace) return _workspace:equals(workspace)  end)
end

function workspaceManager:deleteAllWorkspaces()
    self.workspaces = {}
end

function workspaceManager:getAllWorkspaces()
    return self.workspaces
end

function workspaceManager:getAllActiveWorkspaces()
    return lodash.filter(self:getAllWorkspaces(),
            function(workspace) return workspace:getStatus()  end)
end

function workspaceManager:getWorkspaceByIndex(index)
    return self.workspaces[index]
end

function workspaceManager:findIndexByWorkspace(workspace)
    return lodash.findIndex(self.workspaces, function(_workspace) return _workspace:equals(workspace)  end)
end

function workspaceManager:setStatusForAllWorkspaces(status)
    lodash.forEach(self.workspaces,
function (workspace)
                workspace:setStatus(status)
            end
    )
end

function workspaceManager:switchTo(workspace)
    self:setStatusForAllWorkspaces(false)
    workspace:setStatus(true)
end

return workspaceManager
