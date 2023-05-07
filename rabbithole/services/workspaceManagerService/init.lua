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
    self:saveSession()
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


    __.forEach(loadedModel.workspaces, function(workspace_model)
        return self:restoreWorkspace(workspace_model)
    end)

     self:restoreWorkspace(loadedModel.global_workspace, true)

     -- manually apply rules after startup 
    --  awesome.connect_signal("startup", function()
    --     __.forEach(client.get(), function(c)
    --         awful.rules.apply(c)
    --     end)
    --  end)

end


-- create workspace by definition
-- @param definition table of workspace definition
--     definition = {
--         name = "workspace name",
--         tags = {
--             {name="tag name", selected=true, activated=true, hidden=false, index=1, layout="layout name", clients={ {class="classname", exe="executable"} } },
--             {name="tag name", selected=true, activated=true, hidden=false, index=1, layout="layout name", clients={ {class="classname", exe="executable"} } },
--             ...
--         }
--     }
-- @usage WorkspaceManagerService:restoreWorkspace(definition)
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

        self:restoreClientsForTag(tag, tag_definition.clients)
    end)
end


function WorkspaceManagerService:restoreClientsForTag(tag, clients)
    -- set rules on all the clients
    __.forEach(clients, function(c)
        __.push(awful.rules.rules, self:createRuleForTag(tag, c) )
    end)
end

function WorkspaceManagerService:createRuleForTag(tag, c)
    print("creating rule for tag")
    return {
        rule_any = {
            pid = {c.pid},
            class = {c.class},
        },
        callback = function(cl)
            -- print("callback")
            print(string.format("c.pid: %s, c.class: %s, c.name: %s, tag.name: %s", cl.pid, cl.class, cl.name, tag.name))
            tag.activated = true
            cl:move_to_tag(tag)
        end

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
    local tag = sharedtags.add(nil, {
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

function WorkspaceManagerService:unpauseService()
    capi.awesome.disconnect_signal("refresh", self.unpauseServiceHelper)
    self:setStatusForAllWorkspaces(false)
    self.pauseState:setStatus(true)
    self.pauseState = nil
end

function WorkspaceManagerService:screenDisconnectUpdate(s)

    self:pauseService()

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

end

return WorkspaceManagerService
