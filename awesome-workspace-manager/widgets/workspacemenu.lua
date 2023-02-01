-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
local naughty = require("naughty")
local serpent = require("serpent")
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
    self.workspace_view = self:get_view()

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
                            { "remove", function()  self:removeWorkspace(workspace) end}
                        }
                    }
                end)),

    })
    menu:add({ "add workspace", function () self:add_workspace() end})
    return menu
end

-- create dropdown menu and return it
function WorkspaceMenuController:get_view()
    self.workspace_view = wibox.widget.textbox()
    self:set_text(self.workspaceManagerService:getActiveWorkspace():getName() or "X")
    self.workspace_view:buttons(gears.table.join(
            awful.button({ }, 1,
                    function (textbox)
                        self.workspace_menu:toggle({
                            coords = {
                                x = textbox.x,
                                y = textbox.y + textbox.height
                            }
                        })
                    end)
    ))
    return self.workspace_view
end

-- set the text of the widget
function WorkspaceMenuController:set_text(text)
    self.workspace_view:set_text(" Workspace: " .. text .. " ")
end

function WorkspaceMenuController:get_all_workspaces()
    return self.workspaceManagerService:getAllWorkspaces()
end

function WorkspaceMenuController:switch_to(workspace)
    self.workspaceManagerService:switchTo(workspace)
    self:set_text(workspace:getName())
end

function WorkspaceMenuController:add_workspace()
    local workspace  = self.workspaceManagerService:addWorkspace()
    self:updateMenu()
    self:set_text(workspace:getName())
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
            self:set_text(workspace:getName())
        end
    }
end

function _M.get(workspaceManagerService)
    local wmc = WorkspaceMenuController:new(workspaceManagerService)

    return wmc.workspace_view

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, workspaceManagerService) return _M.get(workspaceManagerService) end })