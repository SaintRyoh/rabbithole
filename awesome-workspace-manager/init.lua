--- This should allow tags to stay organized when dynamically adding/removing screens
--- The basic idea is that tags aren't workspaces, they are just tags, and workspaces are collections of tags.
-- @module workspaceManager
-- @author Matt Mann
-- @copyright 2022 Matt Mann
-- @license MIT

local lodash = require("lodash")
local gears = require("gears")


local workspace = { }
workspace.__index = workspace

function workspace:new(name, tags)
    self = {}
    setmetatable(self, workspace)

    self.name = name or nil
    self.tags = tags or {}
    math.randomseed(os.time())
    self.id = math.random(1000000)

    self.last_selected_tags = {}

    return self
end

function workspace:addTag(tag)
    lodash.push(self.tags, tag)
end

function workspace:addTags(tags)
    self.tags = gears.table.join(self.tags, tags)
end

function workspace:removeTag(_tag)
    lodash.remove(self.tags, function(tag) return tag == _tag end)
end

function workspace:removeAllTagsInWorkspace()
    self.tags = {}
end

function workspace:numberOfTags()
    return #self.tags
end

function workspace:getAllTags()
    return self.tags
end

function workspace:setStatus(status)
    -- If we're about to deactivate a workspace backup the selected tags
    if status == false then
        -- For some reason lodash.filter() didn't work
        lodash.forEach(self.tags, function(tag)
            if tag.selected == true then
                table.insert(self.last_selected_tags, tag)
            end
        end)
        lodash.forEach(self.tags, function(tag) tag.activated = status  end)
    else
        lodash.forEach(self.tags, function(tag) tag.activated = status  end)
        lodash.forEach(self.last_selected_tags, function(tag) tag.selected=true  end)
        self.last_selected_tags = {}
    end
end

function workspace:getStatus()
    return lodash.every(self.tags, function (tag) return tag.activated end)
end

function workspace:toggleStatus()
    self:setStatus(not self:getStatus())
end

function workspace:equals(otherWorkspace)
    return self.id == otherWorkspace.id
end


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
