
local naughty = require("naughty")
local awful     = require("awful")
local sharedtags = require("awesome-sharedtags")
local __ = require("lodash")
local workspaceManager = require("workspaceManager")

local capi = {
    screen = screen
}

local WorkspaceManagerService = { }
WorkspaceManagerService.__index = WorkspaceManagerService

function WorkspaceManagerService:new()
    self = {}
    setmetatable(self, WorkspaceManagerService)

    self.workspaceManagerModel  = workspaceManager:new()
    local workspace = self.workspaceManagerModel:createWorkspace()
    self.workspaceManagerModel:switchTo(workspace)

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
        self:setup_tags_on_screen(s)
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

    self:setup_tags()
end

function WorkspaceManagerService:switchTo(workspace)
    self.workspaceManagerModel:switchTo(workspace) 
end

function WorkspaceManagerService:getAllWorkspaces()
    return self.workspaceManagerModel:getAllWorkspaces()
end


local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    return WorkspaceManagerService:new()
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })