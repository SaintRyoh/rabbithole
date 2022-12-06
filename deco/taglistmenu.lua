-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
-- }}}

local _M = {}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local TaglistMenuController = { }
TaglistMenuController.__index = TaglistMenuController

function TaglistMenuController:new(workspaceManagerService)
    self = {}
    setmetatable(self, TaglistMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.taglist_menu = self:generate_menu()

    return self
end

function TaglistMenuController:generate_menu(t)
    local menu = awful.menu({ })
    menu:add({"move to workspace", 
        __.map(self:get_all_workspaces(), function(workspace, index)
            return {
                workspace.name or ("workspace: " .. index),
                function ()
                    self.workspaceManagerService:moveTagToWorkspace(t, workspace)
                end
            }
        end)
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



function _M.get(workspaceManagerService)
    local wmc = TaglistMenuController:new(workspaceManagerService)

    return wmc

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, workspaceManagerService) return _M.get(workspaceManagerService) end })