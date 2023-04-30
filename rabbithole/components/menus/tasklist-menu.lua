-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
local viewHelper = require("rabbithole.components.viewHelper")
-- }}}

local _M = {}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local TasklistMenuController = { }
TasklistMenuController.__index = TasklistMenuController

function TasklistMenuController:new(workspaceManagerService, c)
    self = {}
    setmetatable(self, TasklistMenuController)

    self.workspaceManagerService = workspaceManagerService
    self.tasklist_menu = self:updateMenu(c)


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
    if self.tasklist_menu then
        self.tasklist_menu:hide()
    end
    self.tasklist_menu = self:generate_menu(c)
    self.tasklist_menu.toggle = viewHelper.decorate_method(self.tasklist_menu.toggle, function()
        self:updateMenu(c)
    end)
    return self.tasklist_menu
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __constructor = function(workspaceManagerService)
        return function(c)
            return TasklistMenuController:new(workspaceManagerService, c).tasklist_menu
        end
    end,
})