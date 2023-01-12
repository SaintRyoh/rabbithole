
local naughty = require("naughty")
local awful     = require("awful")
local sharedtags = require("awesome-sharedtags")
local __ = require("lodash")
local workspaceManager = require("awesome-workspace-manager.workspaceManager")
local serpent = require("serpent")
local gears = require("gears")
local exe = require("awesome-executable-service")

local capi = {
    screen = screen,
    client = client,
    awesome = awesome
}

local WorkspaceManagerService = { }
WorkspaceManagerService.__index = WorkspaceManagerService

function WorkspaceManagerService:new()
    self = {}
    setmetatable(self, WorkspaceManagerService)

    self.workspaceManagerModel = workspaceManager:new()
    self.path = gears.filesystem.get_configuration_dir() .. "/awesome-workspace-manager/session.lua"
    -- check if session file exists
    local file = io.open(self.path, "r")
    if file then
        file:close()
        self:loadSession()
    else
        self:newSession()
    end
    self.pauseState = {
        activeWorkspaces = nil
    }

    self.unpauseServiceHelper = function ()
        self:unpauseService()
    end

    capi.screen.connect_signal("removed", function (s)
        self:screenDisconnectUpdate(s)
    end)


    return self
end

function WorkspaceManagerService:newSession()
    self.workspaceManagerModel:deleteAllWorkspaces()
    local workspace = self.workspaceManagerModel:createWorkspace()
    self.workspaceManagerModel:switchTo(workspace)
    self:saveSession()
end

function WorkspaceManagerService:saveSession()
    local file,err = io.open(self.path, "w")
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
    local file,err = io.open(self.path , "r")
    if not file then
        naughty.notify({
            title="Error loading session",
            text=err,
            timeout=0
        })
       return
    end
    local session = file:read("*all")
    local _, loadedModel = serpent.load(session, {safe = false})
    file:close()
    if not _ then
        naughty.notify({
            title="Error loading session",
            text="Error parsing session file",
            timeout=5
        })
        return
    end
    -- notify how many workspaces were loaded
    -- naughty.notify({
    --     title="Loaded session",
    --     text="Loaded " .. #loadedModel.workspaces .. " workspaces",
    --     timeout=5
    -- })
    -- serpent dump notify
    -- naughty.notify({
    --     title="Loaded session",
    --     text=serpent.block(loadedModel),
    --     timeout=0
    -- })
    self.tagsToRestore = {}
    __.forEach(loadedModel.workspaces, function(workspace_model)
        self:restoreWorkspace(workspace_model)
    end)
    self.restoreClientsForTagHelper  = function()
        __.forEach(self.tagsToRestore, function(tagToRestore)
            self:restoreClientsForTag(tagToRestore.tag, tagToRestore.tag_model)
        end)
    end
    capi.awesome.connect_signal("refresh", self.restoreClientsForTagHelper)
    self.workspaceManagerModel:switchTo(__.first(self.workspaceManagerModel:getAllWorkspaces()))
end

function WorkspaceManagerService:restoreWorkspace(workspace_model)
    local workspace = self.workspaceManagerModel:createWorkspace(workspace_model.name)
    self:restoreTagsForWorkspace(workspace, workspace_model)
end

function WorkspaceManagerService:restoreTagsForWorkspace(workspace, workspace_model)
    __.forEach(workspace_model.tags, function(tag_model)
        local tag = self:createTag(nil, { 
            name = tag_model.name,
            selected = tag_model.selected,
            activated = tag_model.activated,
            hidden = tag_model.hidden,
            index = tag_model.index,
            layout = tag_model.layout
        })
        tag.selected = tag.selected or false
        tag.activated = tag.activated or false
        tag.hidden = tag.hidden or false
        tag.index = tag.index or 1
        workspace:addTag(tag)

        table.insert(self.tagsToRestore, {
            tag = tag,
            tag_model = tag_model
        })
            
    end)
end

-- check if client is already running, if so, then move it to the new tag
-- otherwise, spawn it
function WorkspaceManagerService:restoreClientsForTag(tag, tag_model)
    capi.awesome.disconnect_signal("refresh", self.restoreClientsForTagHelper)
    __.forEach(tag_model.clients, function(client)
        -- dump capi.client.get() to notify
        -- naughty.notify({
        --     title="Clients",
        --     text=serpent.dump(capi.client.get()),
        --     timeout=0
        -- })
        local c = __.find(capi.client.get(), function(c) return c.class == client.class end)
        if c then
            c:move_to_tag(tag)
            -- naughty.notify({
            --     title="Moved client",
            --     text=c.class,
            --     timeout=0
            -- })
        else
        -- naughty.notify({
        --     title="lauching client",
        --     text=client.class,
        --     timeout=0
        -- })
            -- try spawning with client.class (with invalid characters removed), if that fails, then try with client.exe 
            -- if it fails, then notify the user
            -- if it launches successfully, move it to the tag
            -- use awful.spawn to launch the clients

            local pid, notiId = awful.spawn(string.lower(client.class), {tag = tag})
            if notiId == nil then
                pid, notiId = awful.spawn(client.exe, {tag = tag})
                if notiId == nil then
                    naughty.notify({
                        title="Error restoring client",
                        text=notiId,
                        timeout=0
                    })
                -- else
                --     naughty.notify({
                --         title="Restored client with exe",
                --         text=client.class,
                --         timeout=0
                --     })
                end
            -- else
            --     naughty.notify({
            --         title="Restored client with class",
            --         text=client.class,
            --         timeout=0
            --     })
            end
        end
    end)
    
end

function WorkspaceManagerService:setupTagsOnScreen(s)

    local all_active_workspaces = self.workspaceManagerModel:getAllActiveWorkspaces()
    local all_tags = __.flatten(__.map(all_active_workspaces, function(workspace) return workspace:getAllTags() end))
    local unselected_tags = __.filter(all_tags, function(tag) return not tag.selected end)


    local tag = __.first(unselected_tags)

    -- if tag then
    --     naughty.notify({
    --     title="setup tags",
    --     text="recycling tag:" .. tag.name,
    --     timeout=0
    --     })
    -- end

    -- if not, then make one
    if not tag then
        local last_workspace = __.last(all_active_workspaces) or __.first(self.workspaceManagerModel:getAllWorkspaces())
        tag = self:createTag(#self.workspaceManagerModel:getAllWorkspaces() .. "." .. #last_workspace:getAllTags()+1, { layout = awful.layout.layouts[2] })
        last_workspace:addTag(tag)
        last_workspace:setStatus(true)
    end

    sharedtags.viewonly(tag, s)

end

function WorkspaceManagerService:setupTags()
    for s in capi.screen do
        self:setupTagsOnScreen(s)
    end
end

-- {{{ Dynamic tagging


-- Add a new tag
function WorkspaceManagerService:addTagToWorkspace(workspace)
    local workspace = workspace or __.last(self.workspaceManagerModel:getAllActiveWorkspaces())
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(name)
            if not name or #name == 0 then return end
            local tag = self:createTag(name, { awful.layout.layouts[2] })
            workspace:addTag(tag)
            sharedtags.viewonly(tag, awful.screen.focused())
        end
    }
end

function WorkspaceManagerService:createTag(index, tag_def)
    return sharedtags.add(index, tag_def)
end

-- Rename current tag
function WorkspaceManagerService:renameCurrentTag()
    awful.prompt.run {
        prompt       = "Rename tag: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
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
function WorkspaceManagerService:deleteTagFromWorkspace(workspace)
    local workspace = workspace or __.last(self:getAllActiveWorkspaces())
    local t = awful.screen.focused().selected_tag
    if not t then return end
    workspace:removeTag(t)
    t:delete()
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
end

function WorkspaceManagerService:addWorkspace(name)
    local workspace = self.workspaceManagerModel:createWorkspace(name)
    self.workspaceManagerModel:switchTo(workspace)

    self:setupTags()
end

function WorkspaceManagerService:switchTo(workspace)
    self.workspaceManagerModel:switchTo(workspace) 
    if workspace:numberOfTags() < capi.screen:count() then 
        self:setupTags()
    end
    for s in capi.screen do
        if #s.selected_tags == 0 then
            self:setupTagsOnScreen(s)
        end
    end
end

function WorkspaceManagerService:moveTagToWorkspace(tag, workspace)
    self:getWorkspaceByTag(tag):removeTag(tag)
    workspace:addTag(tag)
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

function WorkspaceManagerService:moveGlobalTagToWorkspace(tag, workspace)
    self:getGlobalWorkspace():removeTag(tag)
    workspace:addTag(tag)
    -- simple way to update the tag list
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
    self.pauseState.activeWorkspaces = self:getAllActiveWorkspaces()

    self:setStatusForAllWorkspaces(true)
end

function WorkspaceManagerService:unpauseService()
    if not __.get(self.pauseState, {"activeWorkspaces"}) then
        return
    end
    self:setStatusForAllWorkspaces(false)
    __.forEach(self.pauseState.activeWorkspaces, function(workspace) workspace:setStatus(true) end)
    self.pauseState.activeWorkspaces = nil
    capi.awesome.disconnect_signal("refresh", self.unpauseServiceHelper)
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

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    return WorkspaceManagerService:new()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })