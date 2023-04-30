-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
-- }}}

local _M = {}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local TasklistMenuController = { }
TasklistMenuController.__index = TasklistMenuController

function TasklistMenuController:new(workspaceManagerService)
    self = {}
    setmetatable(self, TasklistMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.tasklist_menu = self:generate_menu()

    return self
end

function TasklistMenuController:generate_menu(c)
    local menu = awful.menu({ })
    menu:add({"move to tag", 
        __.map(self:get_all_workspaces(), function(workspace, index)
            return {
                workspace.name or ("workspace: " .. index),
                __.map(workspace:getAllTags(), function (tag)
                    return { tag.name, function () c:move_to_tag(tag) end }
                end)
            }
        end)
    })
    menu:add({"move to global tag", 
        __.map(self.workspaceManagerService:getGlobalWorkspace():getAllTags(), function(tag)
            return { tag.name, function () c:move_to_tag(tag) end }
        end)
    })

    return menu
end

function TasklistMenuController:get_all_workspaces()
    return self.workspaceManagerService:getAllWorkspaces()
end


function TasklistMenuController:updateMenu(c)
    self.tasklist_menu:hide()
    self.tasklist_menu = self:generate_menu(c)
end



function _M.get(workspaceManagerService)
    local wmc = TasklistMenuController:new(workspaceManagerService)

    return wmc

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __constructor = function(workspaceManagerService)
        return _M.get(workspaceManagerService)
    end,
})