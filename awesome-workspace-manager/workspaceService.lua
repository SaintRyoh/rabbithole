local sharedtags = require("awesome-sharedtags")
local configuration = require("workspaceDefaultConfiguration")
local functools = require("std.functional")
local tagService = require("tagService")

-- crud for workspaces
workspaceService = {
    workspaces = {},
    configuration = {}
}

-- needs to be singleton
function workspaceService:new(_configuration)
    o = {}
    setmetatable(o, self)
    self.__index = self
    -- default configuration
    self.configuration = _configuration or configuration
    return o
end

function workspaceService:createWorkspace(tag_properties)
    return functools.compose(
        function() return self:createTagForWorkspace(self.configuration, tag_properties) end
        ,function(tag) return self:addTagToWorkspace(#self.workspaces + 1, tag) end
    )
end

function workspaceService:deleteWorkspace(workspace_id)
    return functools.compose(
        function() return self:deleteAllTagsInWorkspace(workspace_id) end
        ,function()   return self:_deleteWorkspace(workspace_id) end
        ,function(ret) return Tuple(ret, ret)  end
    )
end

function workspaceService:_deleteWorkspace(workspace_id)
    table.remove(self.workspaces, workspace_id)
    return nil
end

function workspaceService:getAllWorkspaces()
    return self.workspaces
end

function workspaceService:deleteAllWorkspaces()
    return functools.map(self:getAllWorkspaces(), function(workspace) self:deleteWorkspace(workspace_id)  end)
end

function workspaceService:getStatus(workspace_id)
    return Tuple(workspace_id, self.workspaces[workspace_id].activated)
end

function workspaceService:setStatus(workspace_id, status)
    self.workspaces[workspace_id].activated = status
    return Tuple(workspace_id, status)
end

function workspaceService:addTagToWorkspace(workspace_id, tag)
    table.insert(self.workspaces[workspace_id], tag)
end

function workspaceService:createTagForWorkspace(_configuration, tag_properties)
    return sharedtags.new(tag_properties or {
        -- Normal Tag Properties
        name = _name or _configuration.TAG_DEFAULT_NAME,
        layout = _layout or _configuration.TAG_DEFAULT_LAYOUT,
        activated = self.default_status or _configuration.TAG_DEFAULT_STATUS
    })
end

function workspaceService:removeTagFromWorkspace(workspace_id, tag_id)
    table.remove(self.workspaces[workspace_id], tag_id)
    return nil
end

function workspaceService:getAllTags(workspace_id)
    return self.workspaces[workspace_id]
end

function workspaceService:deleteAllTagsInWorkspace(workspace_id)
    return functools.compose(
        functools.map(sef.getAllTags(workspace_id), function(tag) tag:delete()  end)
        ,function (list) return workspace_id end
    )
end

function workspaceService:getTagFromWorkspace(workspace_id, tag_id)
    return self.workspaces[workspace_id][tag_id]
end

function workspaceService:setTagFromWorkspace(workspace_id, tag)
    table.insert(self.workspaces, tag)
    return Tuple(#self.workspaces[workspace_id], tag)
end


return workspaceService