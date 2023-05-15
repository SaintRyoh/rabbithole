local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")
local sharedtags = require("sub.awesome-sharedtags")
local __ = require("lodash")
local workspaceManager = require("rabbithole.services.workspaceManagerService.workspaceManager")
local serpent = require("serpent")

local capi = {
    screen = screen,
    client = client,
    awesome = awesome
}

local WorkspaceManagerService = {}
WorkspaceManagerService.__index = WorkspaceManagerService

function WorkspaceManagerService.new(rabbithole__services__modal)
    local self = {}
    setmetatable(self, WorkspaceManagerService)

    self.workspaceManagerModel = workspaceManager:new()
    self.modal = rabbithole__services__modal

    -- pause stuff
    self.pauseState = nil
    self.restore = {}


    capi.screen.connect_signal("removed", function (s)
        self:screenDisconnectUpdate(s)
    end)


    self.unpauseServiceHelper = function ()
        self:unpauseService()
    end

    -- load sesison
    self.path = gears.filesystem.get_configuration_dir() .. "/rabbithole/session.dat"

    local status, err = pcall(function ()
        self:loadSession() 
    end)

    if not status then
        -- self:backupSessionFile(self.path)
        naughty.notify({
            title="Error loading session",
            text=err,
            timeout=0
        })
        self:newSession()
        self.session_restored = false
    else
        self.session_restored = true
    end

    -- make a timer to periodically save the session
    self.saveSessionTimer = gears.timer({
        timeout = 5,
        autostart = false,
        callback = function()
            self:saveSession()
        end
    })


    -- observer
    self.subscribers = {}

    return self
end

-- rename session.lua to session.lua.bak
function WorkspaceManagerService:backupSessionFile(file_path)
    if gears.filesystem.file_readable(file_path) then
        os.remove(file_path .. ".bak")
        os.rename(file_path, file_path .. ".bak")
    end
end

function WorkspaceManagerService:newSession()
    self.workspaceManagerModel:deleteAllWorkspaces()
    local workspace = self.workspaceManagerModel:createWorkspace("New Workspace")
    workspace:setStatus(true)
    self:switchTo(workspace)
end

function WorkspaceManagerService:saveSession()
    local file,err = io.open(self.path, "w+")
    if not file then
        naughty.notify({
            title="Error saving session",
            text=err,
            timeout=0
        })
       return
    end
    file:write(serpent.dump(self.workspaceManagerModel))
    file:close()
end

-- method to load session
function WorkspaceManagerService:loadSession()
    local file,err = io.open(self.path , "r+")
    if not file then
        naughty.notify({
            title="Error loading session",
            text=err,
            timeout=0
        })
        error(err)
    end

    local session = file:read("*all")
    file:close()
    local _, loadedModel = serpent.load(session, {safe = false})
    if not _ then
        naughty.notify({
            title="Error loading session",
            text="Error parsing session file",
            timeout=0
        })
        error("Error parsing session file")
    end

    -- Store the currently selected workspace and tag indices
    local selected_workspace_index, selected_tag_index
    for idx, workspace in ipairs(self.workspaceManagerModel:getAllWorkspaces()) do
        local selected_tag = workspace:getSelectedTag()
        if selected_tag then
            selected_workspace_index = idx
            selected_tag_index = selected_tag.index
            break
        end
    end

    __.forEach(loadedModel.workspaces, function(workspace_model)
        return self:restoreWorkspace(workspace_model)
    end)

    self:restoreWorkspace(loadedModel.global_workspace, true)

    awful.rules.add_rule_source("workspaceManagerService", function(c, properties, callbacks)
        Debugger.dbg()
        local tag_client = __.first(__.remove(self.restore, function(r) return r.pid == c.pid end))

        if not tag_client or __.isEmpty(tag_client) then
            return
        end

        properties.tag = tag_client.tag,

        __.push(callbacks, function(cl)
            tag_client.tag.activated = true
            cl:move_to_tag(tag_client.tag)
        end)

        if __.isEmpty(self.restore) then
            awful.rules.remove_rule_source("workspaceManagerService")
        end
    end)

end



-- create workspace by definition
function WorkspaceManagerService:restoreWorkspace(definition, global)
    global = global or false

    local workspace = nil
    if global then
        workspace = self:getGlobalWorkspace()
    else
        workspace = self.workspaceManagerModel:createWorkspace(definition.name)
    end

    local function getLayoutByName(name)
        return __.find(awful.layout.layouts, function(layout)
            return layout.name == name
        end)
    end

    local function tagsAreEqual(tag1, tag2)
        return tag1.name == tag2.name and tag1.index == tag2.index and tag1.activated == tag2.activated and tag1.hidden == tag2.hidden
    end


    __.forEach(definition.tags, function(tag_definition, index)
        local tag = self:createTag(index, {
            name = tag_definition.name,
            hidden = tag_definition.hidden,
            index = tag_definition.index,
            layout = getLayoutByName(tag_definition.layout.name)
        })
        tag.selected = false
        tag.activated = tag_definition.activated

        -- if tag in tag_definition.last_selected_tags, then add it to the workspace's last_selected_tags
        if __.find(definition.last_selected_tags, function(t) return tagsAreEqual(t, tag_definition) end) then
            workspace:addLastSelectedTag(tag)
        end

        workspace:addTag(tag)
        if __.every(workspace:getAllTags(), function(t) return t.activated end) then
            workspace.activated = true
        end

        if #tag_definition.clients > 0 then
            Debugger.dbg()
        end
        -- return self:createClientRulesForTag(tag, tag_definition.clients)
        self.restore = gears.table.join(self.restore, __.map(tag_definition.clients, function(client)
            return { tag = tag, pid = client.pid }
        end))
    end)
end


function WorkspaceManagerService:createClientRulesForTag(tag, clients)
    return __.map(clients, function(c)
        return self:createRuleForClient(tag, c)
    end) 
end

function WorkspaceManagerService:createRuleForClient(tag, c)
    return {
        rule = {
            pid = c.pid,
            class = c.class,
            name = c.name,
        },
        properties = {
            tag = tag,
            callback = function(cl)
                tag.activated = true
                cl:move_to_tag(tag)
            end
        }
    }
end

function WorkspaceManagerService:subscribeController(widget)
    __.push(self.subscribers, widget)
end

function WorkspaceManagerService:unsubscribeController(widget)
    __.remove(self.subscribers, widget)
end

function WorkspaceManagerService:updateSubscribers()
    __.forEach(self.subscribers, function (widget)
        if widget.update then
            widget:update()
        end
    end)
end

function WorkspaceManagerService:setupTags()
    local last_workspace = self:getActiveWorkspace()
    local tag = sharedtags.add(#last_workspace:getAllTags()+1, {
        name = last_workspace:getName(#self.workspaceManagerModel:getAllWorkspaces()) .. "." .. #last_workspace:getAllTags()+1,
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
    self.modal.prompt({
        prompt = "New Tag Name: ",
        exe_callback = function(name)
            if not name or #name == 0 then return end
            local index = #self:getAllTags() + #self:getGlobalWorkspace():getAllTags() + 1
            local tag = self:createTag(index, { name = name, layout = awful.layout.layouts[2] })
            workspace:addTag(tag)
            sharedtags.viewonly(tag, awful.screen.focused())
            self:refresh()
        end
    }):show()
end

function WorkspaceManagerService:createTag(index, tag_def)
    return sharedtags.add(index, tag_def)
end

-- Rename current tag
function WorkspaceManagerService:renameTag(tag)
    self.modal.prompt({
        prompt       = "Rename tag: ",
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            local t = tag or awful.screen.focused().selected_tag
            if t then
                t.name = new_name
                self:refresh()
            end
        end
    }):show()
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

-- Delete current tag
-- Any rule set on the tag shall be broken
function WorkspaceManagerService:deleteTagFromWorkspace(workspace, tag)
    local workspace = workspace or self:getWorkspaceByTag(tag) or __.last(self:getAllActiveWorkspaces())
    local tag = tag or awful.screen.focused().selected_tag
    -- if number of tags from global and local workspace is equal to number of screen then don't delete
    local total_tags = #self:getGlobalWorkspace():getAllTags() + #workspace:getAllTags()
    if total_tags <= #capi.screen then
        naughty.notify({
            title="Delete Tag",
            text="Can't delete tag. At least one tag is required per screen",
            timeout=3
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
            client:tags({tag2})
        end

        for _, client in ipairs(clients2) do
            client:tags({tag1})
        end

        self:refresh()
    else
        naughty.notify({
            title="Swap Tags",
            text="Cannot swap. One or both tags do not exist.",
            timeout=3
        })
    end
end

-- }}}

function WorkspaceManagerService:removeWorkspace(workspace)
    -- First Delete all the tags and their clients in the workspace
    __.forEach(workspace:getAllTags(),
            function(tag)
                __.forEach(tag:clients(), function(client) client:kill() end)
                tag:delete()
            end)
    -- Then Delete workspace
    self.workspaceManagerModel:deleteWorkspace(workspace)
    self:updateSubscribers()
end

function WorkspaceManagerService:addWorkspace(name)
    local workspace = self.workspaceManagerModel:createWorkspace(name or tostring(#self.workspaceManagerModel:getAllWorkspaces()+1) )
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
    return __.flatten(__.map(self:getAllWorkspaces(), function (workspace)
        return workspace:getAllTags()
    end))
end

function WorkspaceManagerService:getAllActiveTags()
    return __.flatten(__.map(self:getAllActiveWorkspaces(), function (workspace)
        return workspace:getAllTags()
    end))
end

-- get first unselcted tag from all active workspaces
function WorkspaceManagerService:getFirstUnselectedTag()
    return __.first(__.filter(gears.table.join(self:getAllActiveTags(), self:getGlobalWorkspace():getAllTags()), function(tag) return not tag.selected end))
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

function WorkspaceManagerService:refresh()
    self:switchTo(__.first(self:getAllActiveWorkspaces()))

end

function WorkspaceManagerService:getWorkspaceByTag(tag)
    return __.first(__.filter(self:getAllWorkspaces(), function (workspace)
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

function WorkspaceManagerService:setStatusForAllWorkspaces(status)
    self.workspaceManagerModel:setStatusForAllWorkspaces(status)
end

function WorkspaceManagerService:pauseService()
    self.pauseState = self:getActiveWorkspace() 

    self:setStatusForAllWorkspaces(true)
end

function WorkspaceManagerService:clearRestoreRules()
    __.remove(awful.rules.rules, function(rule)
        return __.includes(self.restore_rules, rule)
    end)
    self.restore_rules = {}
end
function WorkspaceManagerService:unpauseService()
    capi.awesome.disconnect_signal("refresh", self.unpauseServiceHelper)
    -- Debugger.dbg()
    for _, c in pairs(capi.client.get()) do
        local matching_rules = awful.rules.matching_rules(c, self.restore_rules)
        __.forEach(matching_rules, function(rule)
            awful.rules.execute(c, rule.properties or {})
        end)
    end
    self:setStatusForAllWorkspaces(false)
    self.pauseState:setStatus(true)
    self.pauseState = nil
end
function WorkspaceManagerService:screenDisconnectUpdate(s)
    self:pauseService()

    self:clearRestoreRules()
    self.restore_rules = __.flatten(__.map(self:getAllTags(), function(tag)
        return self:createClientRulesForTag(tag, tag:clients())
    end))



    -- First give other code a chance to move the tag to another screen
    for _, t in pairs(s.tags) do
        t:emit_signal("request::screen")
    end
    -- Everything that's left: Tell everyone that these tags go away (other code
    -- could e.g. save clients)
    for _, t in pairs(s.tags) do
        t:emit_signal("removal-pending")
    end
    -- Give other code yet another change to save clients
    for _, c in pairs(capi.client.get(s)) do
        c:emit_signal("request::tag", nil, { reason = "screen-removed" })
    end
    -- Then force all clients left to go somewhere random
    local fallback = nil
    for other_screen in capi.screen do
        if #other_screen.tags > 0 then
            fallback = other_screen.tags[1]
            break
        end
    end
    for _, t in pairs(s.tags) do
        t:delete(fallback, true)
    end
    -- If any tag survived until now, forcefully get rid of it
    for _, t in pairs(s.tags) do
        t.activated = false

        if t.data.awful_tag_properties then
            t.data.awful_tag_properties.screen = nil
        end
    end

    -- let all the other events play out the unpause service
    capi.awesome.connect_signal("refresh", self.unpauseServiceHelper)

    self:switchTo(self.pauseState)
    -- bugfix for the screen disconnect bug. didnt need to add a disconnect signal, this works fine
    s.connect_signal(
        function ()
            awesome.restart()
        end
    )
end

return WorkspaceManagerService
