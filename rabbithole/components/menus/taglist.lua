local awful = require("awful")
local __ = require("lodash")


local TaglistMenuController = { }
TaglistMenuController.__index = TaglistMenuController

function TaglistMenuController.new(workspaceManagerService)
    local self = {}
    setmetatable(self, TaglistMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.taglist_menu = self:generate_menu()

    return self
end

function TaglistMenuController:generate_menu(t)
    local menu = awful.menu({ })
    menu:add({"Move to activity...", 
        __.map(self:get_all_workspaces(), function(workspace, index)
            return {
                workspace.name or ("Activity: " .. index),
                function ()
                    self.workspaceManagerService:moveTagToWorkspace(t, workspace)
                end
            }
        end)
    })
    menu:add({
        "Globalize Tag",
        function ()
            self.workspaceManagerService:moveTagToGlobalWorkspace(t)
        end
    })
    menu:add({
        "Delete tag",
        function ()
            self.workspaceManagerService:deleteTagFromWorkspace(nil, t)
        end
    })
    menu:add({
        "Rename tag",
        function ()
            self.workspaceManagerService:renameTag(t)
        end
    })

    return menu
end

function TaglistMenuController:get_all_workspaces()
    return self.workspaceManagerService:getAllWorkspaces()
end


function TaglistMenuController:updateMenu(t)
    self.taglist_menu:hide()
    self.taglist_menu = self:generate_menu(t)
end


return setmetatable(TaglistMenuController, {
    __call = function(self, workspaceManagerService)
        return self.new(workspaceManagerService)
    end
})