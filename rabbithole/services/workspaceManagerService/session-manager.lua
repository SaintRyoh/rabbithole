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

    self.settings = settings.session_manager or { path = gears.filesystem.get_configuration_dir() .. "/rabbithole/session.dat" }

    return self
end

-- rename session.lua to session.lua.bak
function SessionManager.backupSessionFile(file_path)
    if gears.filesystem.file_readable(file_path) then
        os.remove(file_path .. ".bak")
        os.rename(file_path, file_path .. ".bak")
    end
end

function SessionManager:newSession()
    local workspaceManagerModel = workspaceManager:new()
    workspaceManagerModel:createWorkspace("New Workspace"):setStatus(true)
    return workspaceManagerModel
end

function SessionManager:saveSession(workspaceManagerModel)
    local file, err = io.open(self.settings.path, "w+")
    if not file then
        error("Error saving session: " .. err)
    end
    file:write(serpent.dump(workspaceManagerModel))
    file:close()
end

-- method to load session
function SessionManager:loadSession()
    local workspaceManagerModel = workspaceManager:new()

    if not gears.filesystem.file_readable(self.settings.path) then
        error([[ 
            Session file not found. 
            If this is your first time using rabbithole, you can ignore this error.
        ]])
    end

    local file, err = io.open(self.settings.path, "r+")

    if not file then
        error(err)
    end

    local session = file:read("*all")

    file:close()

    local _, loadedModel = serpent.load(session, { safe = false })

    if not _ then
        error("Error parsing session file")
    end

    local restore = __.map(loadedModel.workspaces, function(workspace_model)
        return self:restoreWorkspace(workspaceManagerModel, workspace_model)
    end)

    restore = gears.table.join(restore, self:restoreWorkspace(workspaceManagerModel, loadedModel.global_workspace, true))   

    -- workspaceManagerModel.clients_to_restore = restore

    awful.rules.add_rule_source("workspaceManagerService", function(c, properties, callbacks)
        if __.isEmpty(restore) then
            awful.rules.remove_rule_source("workspaceManagerService")
            return
        end

        local tag_client = __.first(__.remove(restore, function(r) return r.pid == c.pid end))

        if not tag_client or __.isEmpty(tag_client) then
            return
        end

        properties.tag = tag_client.tag

        __.push(callbacks, function(cl)
            tag_client.tag.active = true
            cl:move_to_tag(tag_client.tag)
        end)
    end)

    return workspaceManagerModel
end

-- create workspace by definition
function SessionManager:restoreWorkspace(workspaceManagerModel, definition, global)
    global = global or false
    local clients_to_restore = {}

    local workspace = nil
    if global then
        workspace = workspaceManagerModel.global_workspace
    else
        workspace = workspaceManagerModel:createWorkspace(definition.name)
    end

    local function getLayoutByName(name)
        return __.find(awful.layout.layouts, function(layout)
            return layout.name == name
        end)
    end

    local function tagsAreEqual(tag1, tag2)
        return tag1.name == tag2.name and tag1.index == tag2.index and tag1.active == tag2.active and
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
        tag.activated = true
        tag.active = tag_definition.activated or tag_definition.active

        -- if tag in tag_definition.last_selected_tags, then add it to the workspace's last_selected_tags
        if __.find(definition.last_selected_tags, function(t) return tagsAreEqual(t, tag_definition) end) then
            workspace:addLastSelectedTag(tag)
        end

        workspace:addTag(tag)
        if __.every(workspace:getAllTags(), function(t) return t.activated or t.active end) then
            workspace.active = true
        end

        clients_to_restore = gears.table.join(clients_to_restore, __.map(tag_definition.clients, function(client)
            return { tag = tag, pid = client.pid }
        end))
    end)

    return clients_to_restore
end


return SessionManager