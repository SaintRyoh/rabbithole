local __ = require("lodash")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local viewHelper = require("rabbithole.components.widgets.viewHelper")

local _M = {}

-- workspace menu controller
local WorkspaceMenuController = { }
WorkspaceMenuController.__index = WorkspaceMenuController

function WorkspaceMenuController.new(workspaceManagerService, theme, rabbithole__services__modal)
    local self = { }
    setmetatable(self, WorkspaceMenuController)

    self.theme = theme
    self.model = workspaceManagerService
    self.bindings = viewHelper.load_template(require("rabbithole.components.widgets.workspace-menu.template"), self)
    self.view = {
        bindings = self.bindings
    }
    self:set_menu(self:generate_menu())
    self:set_text(self.model:getActiveWorkspace():getName())
    self.modal = rabbithole__services__modal

    workspaceManagerService:subscribeController(self)

    self.view.bindings.root:connect_signal("mouse::enter", function()
        self.view.bindings.root.bg = theme.bg_focus
        self.view.bindings.workspace_name_container.bg = theme.bg_focus
    end)

    self.view.bindings.root:connect_signal("mouse::leave", function()
        self.view.bindings.root.bg = theme.bg_normal
        self.view.bindings.workspace_name_container.bg = theme.bg_normal
    end)

    return self
end


-- update the menu
function WorkspaceMenuController:update()
    self:updateMenu()
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
    menu:add({ "New Activity...", function () self:add_workspace() end})
    return menu
end

-- generate svg icons
function WorkspaceMenuController:set_icon(workspace_name)
    local config_dir = gears.filesystem.get_configuration_dir()
    local svg_icon_path = config_dir .. "themes/rabbithole/icons/workspace-menu.svg"
    self.view.bindings.workspace_icon.image = svg_icon_path
end

-- get view 
function WorkspaceMenuController:get_view_widget()
    return self.view.bindings.root
end

-- set the text of the widget
function WorkspaceMenuController:set_text(text)
    self.view.bindings.workspace_name.text = text
    self:set_icon(text)
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
    -- Debugger.dbg()
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
        self.view.bindings.root.bg = self.theme.bg_normal
    end)
end

-- rename workspace
function WorkspaceMenuController:rename_workspace(workspace)
    self.modal.prompt( {
        prompt       = "Rename workspace: ",
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            if not workspace then return end
            workspace.name = new_name
            self.model:updateSubscribers()
        end
    }):show()
end

function WorkspaceMenuController:remove_workspace(workspace)
    -- if the workspace if active don't delete it
    -- Debugger.dbg()
    if workspace:getStatus() then
        naughty.notify({
            title="switch to another workspace before removing it",
            timeout=5
        })
        return
    end
    -- Debugger.dbg()

    self.model:removeWorkspace(workspace)

    -- regenerate menu
    self:updateMenu()
    naughty.notify({
        title="removed",
        timeout=5
    })

end

function WorkspaceMenuController:add_workspace()
    self.model:addWorkspace()
    self:updateMenu()
end


function _M.get(workspaceManagerService, theme, modal)
    return WorkspaceMenuController.new(workspaceManagerService, theme, modal)
end

return setmetatable({}, { __call = function(_, workspaceManagerService, theme, modal) return _M.get(workspaceManagerService, theme, modal) end })