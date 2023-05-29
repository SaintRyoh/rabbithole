local awful = require("awful")
local __ = require("lodash")

local GlobalTaglistMenuController = { }
GlobalTaglistMenuController.__index = GlobalTaglistMenuController

function GlobalTaglistMenuController.new(workspaceManagerService)
    local self = {}
    setmetatable(self, GlobalTaglistMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.taglist_menu = self:generate_menu()

    return self
end

function GlobalTaglistMenuController:generate_menu(t)
    local menu = awful.menu({ })
    menu:add({"Send to activity",
        __.map(self:get_all_workspaces(), function(workspace, index)
            return {
                workspace.name or ("Activity: " .. index),
                function ()
                    self.workspaceManagerService:moveGlobalTagToWorkspace(t, workspace)
                end
            }
        end)
    })

    return menu
end

function GlobalTaglistMenuController:get_all_workspaces()
    return self.workspaceManagerService:getAllWorkspaces()
end


function GlobalTaglistMenuController:updateMenu(t)
    self.taglist_menu:hide()
    self.taglist_menu = self:generate_menu(t)
end



return setmetatable(GlobalTaglistMenuController, {
    __call = function(self, workspaceManagerService)
        return self.new(workspaceManagerService)
    end,
})