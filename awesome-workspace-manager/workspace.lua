local lodash = require("lodash")
local gears = require("gears")
local exe = require("awesome-executable-service")

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

function workspace:unselectedAllTags()
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
    local tags = lodash.map(self.tags, function(tag) return {
            name = tag.name,
            selected = tag.selected,
            layout = tag.layout,
            activated = tag.activated,
            -- clients = self.tag:clients()
            clients = lodash.map(tag:clients(), function(client) return {
                name = string.lower(client.name),
                class = string.lower(client.class),
                exe = exe.getExecutableNameByPid(client.pid)
            } 
        end)
        } 
    end)
    return {
        name = self.name,
        tags = tags,
        id = self.id,
        last_selected_tags = self.last_selected_tags
    }
end

return workspace