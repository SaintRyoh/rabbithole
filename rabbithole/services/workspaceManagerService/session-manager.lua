local gears = require("gears")
local awful = require("awful")

local __ = require("lodash")
local workspaceManager = require("rabbithole.services.workspaceManagerService.workspaceManager")
local sharedtags = require("sub.awesome-sharedtags")
local serpent = require("serpent")

local SessionManager = {}
SessionManager.__index = SessionManager

function SessionManager.new(settings)
    local self = setmetatable({}, SessionManager)

    self.restore = {}
    self.workspaceManagerModel = workspaceManager:new()

    self.path = settings.session_manager or gears.filesystem.get_configuration_dir() .. "/rabbithole/session.dat"

    return self
end

-- rename session.lua to session.lua.bak
function SessionManager:backupSessionFile(file_path)
    if gears.filesystem.file_readable(file_path) then
        os.remove(file_path .. ".bak")
        os.rename(file_path, file_path .. ".bak")
    end
end

function SessionManager:newSession()
    self.workspaceManagerModel:deleteAllWorkspaces()
    local workspace = self.workspaceManagerModel:createWorkspace("New Workspace")
    workspace:setStatus(true)
    return self.workspaceManagerModel
end

function SessionManager:saveSession()
    local file, err = io.open(self.path, "w+")
    if not file then
        error("Error saving session: " .. err)
    end
    file:write(serpent.dump(self.workspaceManagerModel))
    file:close()
end

-- method to load session
function SessionManager:loadSession()

    if not gears.filesystem.file_readable(self.path) then
        error([[ 
            Session file not found. 
            If this is your first time using rabbithole, you can ignore this error.
        ]])
    end

    local file, err = io.open(self.path, "r+")

    if not file then
        error(err)
    end

    local session = file:read("*all")

    file:close()

    local _, loadedModel = serpent.load(session, { safe = false })

    if not _ then
        error("Error parsing session file")
    end

    __.forEach(loadedModel.workspaces, function(workspace_model)
        return self:restoreWorkspace(workspace_model)
    end)

    self:restoreWorkspace(loadedModel.global_workspace, true)

    awful.rules.add_rule_source("workspaceManagerService", function(c, properties, callbacks)
        if __.isEmpty(self.restore) then
            awful.rules.remove_rule_source("workspaceManagerService")
        end

        local tag_client = __.first(__.remove(self.restore, function(r) return r.pid == c.pid end))

        if not tag_client or __.isEmpty(tag_client) then
            return
        end

        properties.tag = tag_client.tag

        __.push(callbacks, function(cl)
            tag_client.tag.activated = true
            cl:move_to_tag(tag_client.tag)
        end)
    end)

    return self.workspaceManagerModel
end

-- create workspace by definition
function SessionManager:restoreWorkspace(definition, global)
    global = global or false

    local workspace = nil
    if global then
        workspace = self.workspaceManagerModel.global_workspace
    else
        workspace = self.workspaceManagerModel:createWorkspace(definition.name)
    end

    local function getLayoutByName(name)
        return __.find(awful.layout.layouts, function(layout)
            return layout.name == name
        end)
    end

    local function tagsAreEqual(tag1, tag2)
        return tag1.name == tag2.name and tag1.index == tag2.index and tag1.activated == tag2.activated and
            tag1.hidden == tag2.hidden
    end


    __.forEach(definition.tags, function(tag_definition, index)
        local tag = sharedtags.add(index, {
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

        self.restore = gears.table.join(self.restore, __.map(tag_definition.clients, function(client)
            return { tag = tag, pid = client.pid }
        end))
    end)
end


return SessionManager