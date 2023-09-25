local lodash = require("lodash")
local gears = require("gears")

local Workspace = { }
Workspace.__index = Workspace

function Workspace:new(name, tags, activated)
    self = {}
    setmetatable(self, Workspace)

    self.name = name or nil
    self.tags = tags or {}
    self.id = math.random(1,1000000)
    self.activated = activated or false

    self.last_selected_tags = {}

    self.global_selected_backup = {}

    return self
end

function Workspace:addTag(tag)
    lodash.push(self.tags, tag)
end

function Workspace:addTags(tags)
    self.tags = gears.table.join(self.tags, tags)
end

function Workspace:removeTag(_tag)
    lodash.remove(self.tags, function(tag) return tag == _tag end)
end

function Workspace:removeAllTagsInWorkspace()
    self.tags = {}
end

-- has tag
function Workspace:hasTag(tag)
    return lodash.find(self.tags, function(_tag) return _tag == tag end) ~= nil
end

function Workspace:unselectAllTags()
    lodash.forEach(self.tags, function (tag)
        tag.selected = false
    end)
end

function Workspace:numberOfTags()
    return #self.tags
end

function Workspace:getAllTags()
    return self.tags
end

function Workspace:setStatus(status)
    if status == false then
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
    self.activated = status
end

function Workspace:getSelectedTags()
    return lodash.filter(self.tags, function(tag) return tag.selected end)
end

function Workspace:setGlobalBackup(global_tags)
    self.global_selected_backup = global_tags
end

function Workspace:restoreGlobalBackup()
    lodash.forEach(self.global_selected_backup, function(tag) tag.selected = true end)
end

function Workspace:getStatus()
    return self.activated
end

function Workspace:isEmpty()
    return lodash.isEmpty(self.tags)
end

function Workspace:toggleStatus()
    self:setStatus(not self:getStatus())
end

function Workspace:equals(otherWorkspace)
    return self.id == otherWorkspace.id
end

function Workspace:getName(default)
    if self.name then
        return self.name
    elseif #self.tags > 0 then
        -- split the tag name on the first dot using gsub, return the first part of the split
        return string.gsub(lodash.first(self.tags).name, "%..*", "")
    else 
        return default or nil
    end
end

function Workspace:addLastSelectedTag(tag)
    lodash.push(self.last_selected_tags, tag)
end

function Workspace:__serialize()
    local function serializeClients(clients)
        return lodash.map(clients, function(client)
            return {
                name = client.name,
                class = client.class,
                role = client.role,
                pid = client.pid
            }
        end)
    end
    local function serializeTags(tags)
        return lodash.map(tags, function(tag) return {
            name = tag.name,
            selected = tag.selected,
            layout = {
                name = tag.layout.name
            },
            activated = tag.activated,
            hidden = tag.hidden,
            clients = serializeClients(tag:clients()),
            sharedtagindex = tag.sharedtagindex
        } 
        end)
    end
    return {
        name = self:getName(),
        tags = serializeTags(self.tags),
        id = self.id,
        last_selected_tags = serializeTags(self.last_selected_tags)
    }
end

return Workspace