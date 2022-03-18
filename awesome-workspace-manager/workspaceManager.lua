--- A workspace is a table of shared tags.
-- @module workspaceManager
-- @author Matt Mann
-- @copyright 2022 Matt Mann
-- @license MIT

local sharedtags = require("awesome-sharedtags")
local functools = require("std.functional")
local lodash = require("lodash")

local default_workspace_configuration = require("workspaceDefaultConfiguration")

local workspaceManager = {
    workspaces = {},
    default_workspace_configuration = {}
}

-- needs to be singleton
function workspaceManager:new(_configuration)
    o = {}
    setmetatable(o, self)
    self.__index = self

    -- default configuration
    self.default_workspace_configuration = _configuration or default_workspace_configuration

    return o
end


-- Workspace


function workspaceManager:createWorkspaceWithNewTag(tag_properties)
    return functools.compose(

        function()
            return self:createWorkspace()
        end,

        function(workspace_id)
            return workspace_id, self:createTag(tag_properties)
        end,

        function(workspace_id, tag)
            self:addTagToWorkspace(workspace_id, tag)
            return workspace_id
        end

    )()
end

function workspaceManager:createWorkspace()
    table.insert(self.workspaces, {})
    return #self.workspaces
end

function workspaceManager:deleteWorkspace(workspace_id)
    self:deleteAllTagsInWorkspace(workspace_id)
    table.remove(self.workspaces, workspace_id)
end

function workspaceManager:deleteAllWorkspaces()
    lodash.forEach(lodash.range(#self.workspaces),
function(workspace)
                self:deleteWorkspace(workspace_id)
            end
    )
end

function workspaceManager:addTagToWorkspace(workspace_id, tag)
    table.insert(self.workspaces[workspace_id], tag)
    return #self.workspaces[workspace_id]
end

function workspaceManager:removeTagFromWorkspace(workspace_id, tag)
    local tag_id = lodash.indexOf(self.workspaces[workspace_id], tag)
    table.remove(self.workspaces[workspace_id], tag_id)
end

function workspaceManager:deleteAllTagsInWorkspace(workspace_id)
    lodash.forEach(self.workspaces[workspace_id],
            function(tag)
                self:removeTagFromWorkspace(workspace_id, tag)
                tag:delete()
            end
    )
end

function workspaceManager:getStatus(workspace_id)
    return lodash.first(self.workspaces[workspace_id]).activated
end

function workspaceManager:setStatus(workspace_id, status)
    lodash.forEach(self.workspaces[workspace_id],
function(tag)
                tag.activated = status
            end
    )
end

function workspaceManager:toggleStatus(workspace_id)
    self:setStatus(workspace_id, not self:getStatus(workspace_id))
end

function workspaceManager:setStatusForAllWorkspaces(status)
    lodash.forEach(self.workspaces,
function (workspace)
                lodash.forEach(workspace, function(tag) tag.activated = status  end)
            end
    )
end

function workspaceManager:switchTo(workspace_id)
    self:setStatusForAllWorkspaces(false)
    self:setStatus(workspace_id, true)
end


-- Tags

function workspaceManager:createTag(tag_properties)

    return sharedtags.new(tag_properties or {
        -- Normal  Awful Tag Properties
        name = _name or self.default_workspace_configuration.TAG_DEFAULT_NAME,
        layout = _layout or self.default_workspace_configuration.TAG_DEFAULT_LAYOUT,
        activated = self.default_status or self.default_workspace_configuration.TAG_DEFAULT_STATUS
    })

end


return workspaceManager
