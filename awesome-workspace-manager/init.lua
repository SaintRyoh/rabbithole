--- A workspace is a table of shared tags. This module manages the "activated" field of a tag
-- @module workspaceManager
-- @author Matt Mann
-- @copyright 2022 Matt Mann
-- @license MIT

local lodash = require("lodash")


local workspace = {
    name = '',
    tags = {}
}

function workspace:new(name, tags)
    o = {}
    setmetatable(o, self)
    self.__index = self

    self.name = name or 'no name'
    self.tags = tags or {}

    return o
end

function workspace:addTag(tag)
    lodash.push(self.tags, tag)
end

function workspace:removeTag(_tag)
    lodash.remove(self.tags, function(tag) return tag == _tag end)
end

function workspace:removeAllTagsInWorkspace()
    self.tags = {}
end

function workspace:numberOfTags()
    return lodash.size(self.tags)
end

function workspace:getAllTags()
    return self.tags
end

function workspace:setStatus(status)
    lodash.forEach(self.tags, function(tag) tag.activated = status  end)
end

function workspace:getStatus()
    return lodash.first(self.tags).activated
end


-- needs to be singleton
local workspaceManager = {
    workspaces = {},
}

function workspaceManager:new()
    o = {}
    setmetatable(o, self)
    self.__index = self

    self.workspaces = {}

    return o
end

function workspaceManager:createWorkspace(name, tags)
    lodash.push(self.workspaces, workspace:new(name or 'workspace_' .. lodash.size(self.workspaces), tags or {}))
    return lodash.size(self.workspaces)
end

function workspaceManager:deleteWorkspace(workspace_id)
    self.workspaces[workspace_id]:removeAllTagsInWorkspace()
    table.remove(self.workspaces, workspace_id)
end

function workspaceManager:deleteAllWorkspaces()
    self.workspaces = {}
end

function workspaceManager:getAllWorkspaces()
    return self.workspaces
end

function workspaceManager:getWorkspace(workspace_id)
    return self.workspaces[workspace_id]
end

function workspaceManager:getAllTagsBeingManaged()
    return lodash.flatten(lodash.map(self.workspaces,
        function(workspace)
            return workspace:getAllTags()
        end
    ))
end

function workspaceManager:setStatusForAllWorkspaces(status)
    lodash.forEach(self.workspaces,
function (workspace)
                workspace:setStatus(status)
            end
    )
end

function workspaceManager:switchTo(workspace_id)
    self:setStatusForAllWorkspaces(false)
    self.workspaces[workspace_id]:setStatus(true)
end

return workspaceManager
