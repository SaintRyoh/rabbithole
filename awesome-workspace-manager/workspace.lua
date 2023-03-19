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

    self.global_selected_backup = {}

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

-- has tag
function workspace:hasTag(tag)
    return lodash.find(self.tags, function(_tag) return _tag == tag end) ~= nil
end

function workspace:unselectAllTags()
    __.forEach(self.tags, function (tag)
        tag.selected = false
    end)
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

-- get selected tags
function workspace:getSelectedTags()
    return lodash.filter(self.tags, function(tag) return tag.selected end)
end

--set global backup
function workspace:setGlobalBackup(global_tags)
    self.global_selected_backup = global_tags
end

-- re-select all the tags that were selected before the workspace was activated
function workspace:restoreGlobalBackup()
    lodash.forEach(self.global_selected_backup, function(tag) tag.selected = true end)
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

function workspace:__serialize()
    local function serializeClients(clients)
        return lodash.map(clients, function(client)
            return {
                name = client.name,
                class = client.class
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
            clients = serializeClients(tag:clients())
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

function workspace:getName()
    if self.name then
        return self.name
    elseif #self.tags > 0 then
        -- split the tag name on the first dot using gsub
        -- return the first part of the split
        return string.gsub(lodash.first(self.tags).name, "%..*", "")
    else 
        return nil
    end
end

-- function for adding a tag to last selected tags
function workspace:addLastSelectedTag(tag)
    lodash.push(self.last_selected_tags, tag)
end

return workspace