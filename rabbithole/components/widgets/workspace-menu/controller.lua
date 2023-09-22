local __ = require("lodash")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local viewHelper = require("rabbithole.components.widgets.viewHelper")

local _M = {}

local WorkspaceMenuController = { }
WorkspaceMenuController.__index = WorkspaceMenuController

function WorkspaceMenuController.new(workspaceManagerService, theme, rabbithole__services__modal, animation, color)
    local self = { }
    setmetatable(self, WorkspaceMenuController)

    self.theme = theme
    self.model = workspaceManagerService
    self.color = color
    self.animation = animation
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
        --self.view.bindings.workspace_name_container.bg = theme.bg_focus
    end)

    self.view.bindings.root:connect_signal("mouse::leave", function()
        self.view.bindings.root.bg = theme.bg_normal
        --self.view.bindings.workspace_name_container.bg = theme.bg_normal
    end)

    return self
end


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
                            { "Switch", function() self:switch_to(workspace) end},
                            { "Rename", function() self:rename_workspace(workspace) end},
                            { "Delete", function()  self:remove_workspace(workspace) end}
                        }
                    }
                end))
    })
    menu:add({ "New Activity...", function () self:add_workspace() end})
    menu:add({ "Save Session", function ()
        self.model:saveSession()
    end})

    return menu
end

function WorkspaceMenuController:set_icon(workspace_name)
    local config_dir = gears.filesystem.get_configuration_dir()
    local svg_icon_path = config_dir .. "themes/rabbithole/icons/workspace_menu/workspace-menu.png"
    self.view.bindings.workspace_icon.image = svg_icon_path
end

function WorkspaceMenuController:get_view_widget()
    return self.view.bindings.root
end

function WorkspaceMenuController:set_text(text)
    self:set_icon(text)
end

function WorkspaceMenuController:get_all_workspaces()
    return self.model:getAllWorkspaces()
end

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

function WorkspaceMenuController:rename_workspace(workspace)
    self.model:renameWorkspace(workspace)
end

function WorkspaceMenuController:remove_workspace(workspace)
    self.model:removeWorkspaceWithConfirm(workspace)
    self:updateMenu()
end

function WorkspaceMenuController:add_workspace()
    local new_workspace = self.model:addWorkspace()
    self:rename_workspace(new_workspace)
    self:updateMenu()
end

function _M.get(workspaceManagerService, theme, modal, animation, color)
    return WorkspaceMenuController.new(workspaceManagerService, theme, modal, animation, color)
end

return setmetatable({}, { __call = function(_, workspaceManagerService, theme, modal, animation, color) return _M.get(workspaceManagerService, theme, modal, animation, color) end })