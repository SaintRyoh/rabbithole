--- This should allow tags to stay organized when dynamically adding/removing screens
--- The basic idea is that tags aren't workspaces, they are just tags, and workspaces are collections of tags.
-- @module workspaceManager
-- @author Matt Mann
-- @copyright 2022 Matt Mann
-- @license MIT

local lodash = require("lodash")
local workspace = require("rabbithole.services.workspaceManagerService.workspace")



-- needs to be singleton
local workspaceManager = {}
workspaceManager.__index = workspaceManager

function workspaceManager:new()
    self = {}
    setmetatable(self, workspaceManager)

    self.workspaces = {}

    self.global_workspace = workspace:new('Global')

    return self
end

function workspaceManager:createWorkspace(name, tags, emit_signal)
    local new_workspace = workspace:new(name, tags, emit_signal)
    lodash.push(self.workspaces, new_workspace)
    awesome.emit_signal("workspaceManager::workspace_created")
    return new_workspace
end

function workspaceManager:deleteWorkspace(workspace)
    workspace:removeAllTagsInWorkspace()
    lodash.remove(self.workspaces, function(_workspace) return _workspace:equals(workspace)  end)
    awesome.emit_signal("workspaceManager::workspace_deleted")
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

function workspaceManager:getAllUnactiveWorkspaces()
    return lodash.filter(self:getAllWorkspaces(),
            function(workspace) return not workspace:getStatus()  end)
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
    -- backup the global workspace's selected tags
    local active_workspace = lodash.first( self:getAllActiveWorkspaces() )
    active_workspace:setGlobalBackup(self.global_workspace:getSelectedTags())
    self.global_workspace:unselectAllTags()
    -- maybe in between switches I could set the tags to active so they could process their signals
    self:setStatusForAllWorkspaces(false)
    workspace:setStatus(true)
    workspace:restoreGlobalBackup()
    awesome.emit_signal("workspaceManager::workspace_switch")
end

-- create a __serialize method to allow for serialization
function workspaceManager:__serialize()
    return {
        workspaces = self.workspaces,
        global_workspace = self.global_workspace
    }
end

return workspaceManager
