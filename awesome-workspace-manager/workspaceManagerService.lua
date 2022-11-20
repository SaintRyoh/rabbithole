
local naughty = require("naughty")
local awful     = require("awful")
local sharedtags = require("awesome-sharedtags")
local __ = require("lodash")
local workspaceManager = require("awesome-workspace-manager.workspaceManager")

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

    self.workspaceManagerModel  = workspaceManager:new()
    local workspace = self.workspaceManagerModel:createWorkspace()
    self.workspaceManagerModel:switchTo(workspace)

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


function WorkspaceManagerService:setupTagsOnScreen(s)

    local all_active_workspaces = self.workspaceManagerModel:getAllActiveWorkspaces()
    local all_tags = __.flatten(__.map(all_active_workspaces, function(workspace) return workspace:getAllTags() end))
    local unselected_tags = __.filter(all_tags, function(tag) return not tag.selected end)


    local tag = __.first(unselected_tags)

    if tag then
        naughty.notify({
        title="setup tags",
        text="recycling tag:" .. tag.name,
        timeout=0
        })
    end

    -- if not, then make one
    if not tag then
        local last_workspace = __.last(all_active_workspaces) or __.first(self.workspaceManagerModel:getAllWorkspaces())
        tag = sharedtags.add(#self.workspaceManagerModel:getAllWorkspaces() .. "." .. #last_workspace:getAllTags()+1, { layout = awful.layout.layouts[2] })
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
            local tag = sharedtags.add(name, { awful.layout.layouts[2] })
            workspace:addTag(tag)
            sharedtags.viewonly(tag, awful.screen.focused())
        end
    }
end

function WorkspaceManagerService:createTag(name, layout)
    return sharedtags.add(name, { awful.layout.layouts[2] })
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
    local workspace = workspace or __.last(self.workspaceManagerModel:getAllActiveWorkspaces())
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

function WorkspaceManagerService:addWorkspace()
    local workspace = self.workspaceManagerModel:createWorkspace()
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

function WorkspaceManagerService:getAllWorkspaces()
    return self.workspaceManagerModel:getAllWorkspaces()
end

function WorkspaceManagerService:getAllActiveWorkspaces()
    return self.workspaceManagerModel:getAllActiveWorkspaces()
end

function WorkspaceManagerService:getAllUnactiveWorkspaces()
    return self.workspaceManagerModel:getAllUnactiveWorkspaces()
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