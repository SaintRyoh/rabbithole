-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
local naughty = require("naughty")
-- }}}

local _M = {}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local WorkspaceMenuController = { }
WorkspaceMenuController.__index = WorkspaceMenuController

function WorkspaceMenuController:new(workspaceManagerService)
    self = {}
    setmetatable(self, WorkspaceMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.workspace_menu = self:generate_menu()

    return self
end

function WorkspaceMenuController:generate_menu()
    local menu = awful.menu({
        items = gears.table.join(__.map(self:get_all_workspaces(),
                function(workspace, index)
                    return {
                        workspace.name or ("workspace: " .. index),
                        {
                            { "switch", function() self:switch_to(workspace) end},
                            { "rename", function() self:rename_workspace(workspace) end},
                            { "remove", function()  self:removeWorkspace(workspace) end}
                        }
                    }
                end))
    })
    menu:add({ "add workspace", function () self:add_workspace() end})
    return menu
end

function WorkspaceMenuController:get_all_workspaces()
    return self.workspaceManagerService:getAllWorkspaces()
end

function WorkspaceMenuController:switch_to(workspace)
    self.workspaceManagerService:switchTo(workspace)
end

function WorkspaceMenuController:add_workspace()
    self.workspaceManagerService:addWorkspace()
    self:updateMenu()
end

function WorkspaceMenuController:removeWorkspace(workspace)
    -- if the workspace if active don't delete it
    if workspace:getStatus() then
        naughty.notify({
            title="switch to another workspace before removing it",
            timeout=0
        })
        return
    end

    self.workspaceManagerService:removeWorkspace(workspace)

    -- regenerate menu
    self:updateMenu()

    naughty.notify({
        title="removed workspace",
        timeout=0
    })
end

function WorkspaceMenuController:updateMenu()
    self.workspace_menu = self:generate_menu()
end

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

function _M.get(workspaceManagerService)
    local wmc = WorkspaceMenuController:new(workspaceManagerService)

    -- {{{ workspace dropdownmenu
    local workspace_menu_view = {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.widget.textbox,
            text = "   workspace: X   ",
            buttons = gears.table.join(
                    awful.button({ }, 1,
                            function ()
                                wmc.workspace_menu:toggle()
                            end)
            )
        }
    }

    return workspace_menu_view

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, workspaceManagerService) return _M.get(workspaceManagerService) end })