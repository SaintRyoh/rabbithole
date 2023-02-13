local __ = require("lodash")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local viewHelper = require("awesome-workspace-manager.components.viewHelper")
local beautiful = require("beautiful")

local _M = {}

-- workspace menu controller
local WorkspaceMenuController = { }
WorkspaceMenuController.__index = WorkspaceMenuController

function WorkspaceMenuController:new(workspaceManagerService)
    self = {}
    setmetatable(self, WorkspaceMenuController)

    self.model = workspaceManagerService
    self.bindings = viewHelper.load_template("awesome-workspace-manager/components/workspacemenu/template.lua")
    self.view = {
        bindings = self.bindings
    }
    self:set_menu(self:generate_menu())
    self:set_text(self.model:getActiveWorkspace():getName())

    return self
end

function WorkspaceMenuController:generate_menu()
    local menu = awful.menu({
        items = gears.table.join(__.map(self:get_all_workspaces(),
                function(workspace)
                    return {
                        workspace:getName(),
                        {
                            { "switch", function() self:switch_to(workspace) end},
                            { "rename", function() self:rename_workspace(workspace) end},
                            { "remove", function()  self:remove_workspace(workspace) end}
                        }
                    }
                end))
    })
    menu:add({ "add workspace", function () self:add_workspace() end})
    return menu
end

-- get view 
function WorkspaceMenuController:get_view_widget()
    return self.view.bindings.root
end

-- set the text of the widget
function WorkspaceMenuController:set_text(text)
    self.view.bindings.textbox.text = "Workspace: " .. text
end

-- get all workspaces
function WorkspaceMenuController:get_all_workspaces()
    return self.model:getAllWorkspaces()
end

-- get active workspace
function WorkspaceMenuController:get_active_workspace()
    return self.model:getActiveWorkspace()
end

function WorkspaceMenuController:switch_to(workspace)
    self.model:switchTo(workspace)
    self:updateMenu()
end

function WorkspaceMenuController:updateMenu()
    self:set_menu(self:generate_menu())
    self:set_text(self.model:getActiveWorkspace():getName())
end

-- set menu
function WorkspaceMenuController:set_menu(menu)
    if self.view.bindings.menu ~= nil then
        self.view.bindings.menu:hide()
    end

    self.view.bindings.menu = menu

    self.view.bindings.menu.hide = viewHelper.decorate_method(self.view.bindings.menu.hide, function() 
        self.view.bindings.rotator.direction = "north"
        self.view.bindings.root.bg = beautiful.bg_normal
    end)
end

-- rename workspace
function WorkspaceMenuController:rename_workspace(workspace)
    awful.prompt.run {
        prompt       = "Rename workspace: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            if not workspace then return end
            workspace.name = new_name
            self:updateMenu()
        end
    }
end

function WorkspaceMenuController:remove_workspace(workspace)
    -- if the workspace if active don't delete it
    if workspace:getStatus() then
        naughty.notify({
            title="switch to another workspace before removing it",
            timeout=5
        })
        return
    end

    self.model:removeWorkspace(workspace)

    -- regenerate menu
    self:updateMenu()

    naughty.notify({
        title="removed workspace",
        timeout=5
    })
end

function WorkspaceMenuController:add_workspace()
    self.model:addWorkspace()
    self:updateMenu()
end


function _M.get(workspaceManagerService)
    return WorkspaceMenuController:new(workspaceManagerService)
end

return setmetatable({}, { __call = function(_, workspaceManagerService) return _M.get(workspaceManagerService) end })