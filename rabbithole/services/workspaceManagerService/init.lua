local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")

local sharedtags = require("sub.awesome-sharedtags")
local __ = require("lodash")

local capi = {
    screen = screen,
    client = client,
    awesome = awesome
}

local WorkspaceManagerService = {}
WorkspaceManagerService.__index = WorkspaceManagerService

function WorkspaceManagerService.new(
    rabbithole__services__modal,
    rabbithole__services__workspaceManagerService__session___manager,
    settings
)
    local self = setmetatable({}, WorkspaceManagerService)

    self.modal = rabbithole__services__modal
    self.sessionManager = rabbithole__services__workspaceManagerService__session___manager
    self.settings = settings.workspaceManagerService or {
        enable_autosave = true,
        autosave_wait_time = 1
    }

    local status, err = pcall(function()
        self.workspaceManagerModel = self.sessionManager:loadSession()
    end)

    if not status then
        naughty.notify({
            title = "Error loading session",
            text = err,
            timeout = 0
        })
        self.workspaceManagerModel = self.sessionManager:newSession()
        self:switchTo(self:getActiveWorkspace())
    end

    self:setupAutoSave({
        "workspaceManager::workspace_created",
        "workspaceManager::workspace_deleted",
        "workspaceManager::workspace_switch",
        "workspace::name_changed"
    })

    capi.screen.connect_signal("removed", function ()
        self:saveSession()
        capi.awesome.restart()
    end)

    -- observer
    self.subscribers = {}

    return self
end

function WorkspaceManagerService:setupAutoSave(signals)
    local ready = true
    local timer = gears.timer {
        timeout = self.settings.autosave_wait_time,
        autostart = true,
        callback = function()
            ready = true
        end
    }
    __.forEach(signals, function(signal)
        capi.awesome.connect_signal(signal, function()
            if self.settings.enable_autosave and ready then
                -- self:saveSession()
                naughty.notify({
                    title = "autosave event",
                    text = signal,
                    timeout = 0
                })
                ready = false
            end
        end)
    end)
end

-- save session
-- won't need after I have auto-saving
function WorkspaceManagerService:saveSession()
    -- use pcall 
    local status, err = pcall(function()
        self.sessionManager:saveSession(self.workspaceManagerModel)
    end)
    if not status then
        naughty.notify({
            title = "Error saving session",
            text = err,
            timeout = 0
        })
    else
        -- notify save was successful
        naughty.notify({ title = "Session saved.", timeout = 3 })
    end
end

function WorkspaceManagerService:subscribeController(widget)
    __.push(self.subscribers, widget)
end

function WorkspaceManagerService:unsubscribeController(widget)
    __.remove(self.subscribers, widget)
end

function WorkspaceManagerService:updateSubscribers()
    __.forEach(self.subscribers, function(widget)
        if widget.update then
            widget:update()
        end
    end)
end

function WorkspaceManagerService:setupTags()
    local last_workspace = self:getActiveWorkspace()
    local tag = sharedtags.add(#last_workspace:getAllTags() + 1, {
        name = last_workspace:getName(#self.workspaceManagerModel:getAllWorkspaces()) ..
            "." .. #last_workspace:getAllTags() + 1,
        layout = awful.layout.layouts[2]
    })

    last_workspace:addTag(tag)
    last_workspace:setStatus(true)
end

-- {{{ Dynamic tagging

-- Add a new tag
function WorkspaceManagerService:addTagToWorkspace(workspace)
    local workspace = workspace or __.last(self.workspaceManagerModel:getAllActiveWorkspaces())
    -- open modal prompt to get tag name
    self.modal:prompt({
        prompt = "New Tag Name: ",
        exe_callback = function(name)
            if not name or #name == 0 then return end
            local index = #self:getAllTags() + #self:getGlobalWorkspace():getAllTags() + 1
            local tag = sharedtags.add(index, { name = name, layout = awful.layout.layouts[2] })
            workspace:addTag(tag)
            sharedtags.viewonly(tag, awful.screen.focused())
            self:refresh()
        end
    })
end

-- Rename current tag
function WorkspaceManagerService:renameTag(tag)
    self.modal:prompt({
        prompt       = "Rename tag: ",
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            local t = tag or awful.screen.focused().selected_tag
            if t then
                t.name = new_name
                self:refresh()
            end
        end
    })
end

---- Move current tag
---- pos in {-1, 1} <-> {previous, next} tag position
--- causes error if a tag doesn't have clients. idk why
function WorkspaceManagerService:moveTag(pos)
    local tag = awful.screen.focused().selected_tag
    if tonumber(pos) <= -1 then
        tag.index = tag.index - 1
        --awful.tag.move(tag.index - 1, tag)
    else
        tag.index = tag.index + 1
        --awful.tag.move(tag.index + 1, tag)
    end
end

function WorkspaceManagerService:deleteTagFromWorkspaceWithConfirm(workspace, tag)
    self.modal:confirm({
        title = "Delete Tag",
        message = "Are you sure you want to delete tag: " .. tag.name .. "?",
        yes_callback = function()
            self:deleteTagFromWorkspace(workspace, tag)
        end
    })
end
-- Delete current tag
-- Any rule set on the tag shall be broken
function WorkspaceManagerService:deleteTagFromWorkspace(workspace, tag)
    local workspace = workspace or self:getWorkspaceByTag(tag) or __.last(self:getAllActiveWorkspaces())
    local tag = tag or awful.screen.focused().selected_tag
    -- if number of tags from global and local workspace is equal to number of screen then don't delete
    local total_tags = #self:getGlobalWorkspace():getAllTags() + #workspace:getAllTags()
    if total_tags <= #capi.screen then
        naughty.notify({
            title = "Delete Tag",
            text = "Can't delete tag. At least one tag is required per screen",
            timeout = 3
        })
        return
    end
    if not tag then return end

    local deleted = false
    if workspace:hasTag(tag) then
        workspace:removeTag(tag)
        deleted = true
    elseif self:getGlobalWorkspace():hasTag(tag) then
        self:getGlobalWorkspace():removeTag(tag)
        deleted = true
    end

    if deleted then
        __.forEach(tag:clients(), function(client) client:kill() end)
        tag:delete()
        self:refresh()
    end
end

-- swap tags by index, regardless of workspace. can also be used for drag and drop tags later.
function WorkspaceManagerService:swapTagsByIndex(index1, index2)
    local allTags = self:getAllTags()
    local tag1 = allTags[index1]
    local tag2 = allTags[index2]

    if tag1 and tag2 then
        -- swap tags in their respective workspaces
        local workspace1 = self:getWorkspaceByTag(tag1)
        local workspace2 = self:getWorkspaceByTag(tag2)
        workspace1:removeTag(tag1)
        workspace1:addTag(tag2)
        workspace2:removeTag(tag2)
        workspace2:addTag(tag1)

        -- update sharedtags indexes
        local tmp_index = tag1.index
        tag1.index = tag2.index
        tag2.index = tmp_index

        -- swap clients
        local clients1 = tag1:clients()
        local clients2 = tag2:clients()

        for _, client in ipairs(clients1) do
            client:tags({ tag2 })
        end

        for _, client in ipairs(clients2) do
            client:tags({ tag1 })
        end

        self:refresh()
    else
        naughty.notify({
            title = "Swap Tags",
            text = "Cannot swap. One or both tags do not exist.",
            timeout = 3
        })
    end
end

-- }}}

function WorkspaceManagerService:removeWorkspace(workspace)
    if workspace:getStatus() and not workspace:isEmpty() then
        naughty.notify({
            title="Switch to another workspace before removing it",
            timeout=5
        })
        return
    end
    -- First Delete all the tags and their clients in the workspace
    __.forEach(workspace:getAllTags(),
        function(tag)
            __.forEach(tag:clients(), function(client) client:kill() end)
            tag:delete()
        end)
    -- Then Delete workspace
    self.workspaceManagerModel:deleteWorkspace(workspace)
    self:updateSubscribers()

    naughty.notify({
        title="Workspace " .. workspace.name .. " was removed.",
        timeout=5
    })
end

function WorkspaceManagerService:removeWorkspaceWithConfirm(workspace)
    self.modal:confirm({
        title = "Delete Workspace",
        message = "Are you sure you want to delete workspace: " .. workspace.name .. "?",
        yes_callback = function()
            self:removeWorkspace(workspace)
        end
    })
end


function WorkspaceManagerService:renameWorkspace(workspace)
    self.modal:prompt( {
        prompt       = "New activity name: ",
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            if not workspace then return end
            workspace:setName(new_name)
            self:updateSubscribers()
        end
    })
end

function WorkspaceManagerService:addWorkspace(name)
    local workspace = self.workspaceManagerModel:createWorkspace(name or
        tostring(#self.workspaceManagerModel:getAllWorkspaces() + 1))
    self:switchTo(workspace)
    return workspace
end

-- asigns tags to screens
function WorkspaceManagerService:assignWorkspaceTagsToScreens()
    for s in capi.screen do
        if #s.selected_tags == 0 then
            local first_unselected_tag = self:getFirstUnselectedTag()
            if first_unselected_tag then
                -- dump tag
                -- naughty.notify({
                --     title="assignWorkspaceTagsToScreens",
                --     text=serpent.dump(first_unselected_tag.name),
                --     timeout=0
                -- })
                sharedtags.viewonly(first_unselected_tag, s)
            else
                -- create new tag
                self:setupTags()
            end
        end
    end
end

function WorkspaceManagerService:switchTo(workspace)
    self.workspaceManagerModel:switchTo(workspace)
    self:assignWorkspaceTagsToScreens()
    self:updateSubscribers()
end

function WorkspaceManagerService:moveTagToWorkspace(tag, workspace)
    self:getWorkspaceByTag(tag):removeTag(tag)
    workspace:addTag(tag)
    tag.selected = false
    -- simple way to update the tag list
    self:refresh()
end

function WorkspaceManagerService:getAllTags()
    return __.flatten(__.map(self:getAllWorkspaces(), function(workspace)
        return workspace:getAllTags()
    end))
end

function WorkspaceManagerService:getAllActiveTags()
    return __.flatten(__.map(self:getAllActiveWorkspaces(), function(workspace)
        return workspace:getAllTags()
    end))
end

-- get first unselcted tag from all active workspaces
function WorkspaceManagerService:getFirstUnselectedTag()
    return __.first(__.filter(gears.table.join(self:getAllActiveTags(), self:getGlobalWorkspace():getAllTags()),
        function(tag) return not tag.selected end))
end

-- create a new tag "Global" to global workspace
function WorkspaceManagerService:addGlobalTag()
    local global_workspace = self:getGlobalWorkspace()
    local tag = global_workspace:addTag("Global")
    self:refresh()
    return tag
end

function WorkspaceManagerService:moveGlobalTagToWorkspace(tag, workspace)
    self:getGlobalWorkspace():removeTag(tag)
    workspace:addTag(tag)
    -- simple way to update the tag list
    tag.selected = false
    self:refresh()
end

function WorkspaceManagerService:moveTagToGlobalWorkspace(tag)
    self:getWorkspaceByTag(tag):removeTag(tag)
    self:getGlobalWorkspace():addTag(tag)
    -- simple way to update the tag list
    self:refresh()
end

function WorkspaceManagerService:viewPrevTag()
    local tags = gears.table.join(self:getAllGlobalTags(), self:getAllActiveTags())
    local selected_tag = __.filter(tags, function(tag) return tag.selected end)[1]
    local prev_tag_index = __.findIndex(tags, function(tag) return tag == selected_tag end) - 1
    if prev_tag_index < 1 then
        sharedtags.viewonly(tags[#tags], awful.screen.focused())
    else
        sharedtags.viewonly(tags[prev_tag_index], awful.screen.focused())
    end
end

function WorkspaceManagerService:viewNextTag()
    local tags = gears.table.join(self:getAllGlobalTags(), self:getAllActiveTags())
    local selected_tag = __.filter(tags, function(tag) return tag.selected end)[1]
    local next_tag_index = __.findIndex(tags, function(tag) return tag == selected_tag end) + 1
    if next_tag_index > #tags then
        sharedtags.viewonly(tags[1], awful.screen.focused())
    else
        sharedtags.viewonly(tags[next_tag_index], awful.screen.focused())
    end
end


function WorkspaceManagerService:refresh()
    self:switchTo(self:getActiveWorkspace())
end

function WorkspaceManagerService:getWorkspaceByTag(tag)
    return __.first(__.filter(self:getAllWorkspaces(), function(workspace)
        return __.includes(workspace:getAllTags(), tag)
    end))
end

function WorkspaceManagerService:getAllWorkspaces()
    return self.workspaceManagerModel:getAllWorkspaces()
end

function WorkspaceManagerService:getAllActiveWorkspaces()
    return self.workspaceManagerModel:getAllActiveWorkspaces()
end

function WorkspaceManagerService:getActiveWorkspace()
    return __.first(self:getAllActiveWorkspaces()) or __.first(self:getAllWorkspaces())
end

function WorkspaceManagerService:getAllUnactiveWorkspaces()
    return self.workspaceManagerModel:getAllUnactiveWorkspaces()
end

function WorkspaceManagerService:getGlobalWorkspace()
    return self.workspaceManagerModel.global_workspace
end

function WorkspaceManagerService:tagIsGlobal(tag)
    return __.includes(self:getAllGlobalTags(), tag)
end

function WorkspaceManagerService:getAllGlobalTags()
    return self:getGlobalWorkspace():getAllTags()
end

return WorkspaceManagerService
