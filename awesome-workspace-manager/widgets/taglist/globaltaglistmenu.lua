-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
-- }}}

local _M = {}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local GlobalTaglistMenuController = { }
GlobalTaglistMenuController.__index = GlobalTaglistMenuController

function GlobalTaglistMenuController:new(workspaceManagerService)
    self = {}
    setmetatable(self, GlobalTaglistMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.taglist_menu = self:generate_menu()

    return self
end

function GlobalTaglistMenuController:generate_menu(t)
    local menu = awful.menu({ })
    menu:add({"Send to workspace", 
        __.map(self:get_all_workspaces(), function(workspace, index)
            return {
                workspace.name or ("workspace: " .. index),
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



function _M.get(workspaceManagerService)
    local wmc = GlobalTaglistMenuController:new(workspaceManagerService)

    return wmc

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, workspaceManagerService) return _M.get(workspaceManagerService) end })