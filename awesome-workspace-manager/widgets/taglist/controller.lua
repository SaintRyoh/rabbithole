local __ = require("lodash")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local viewHelper = require("awesome-workspace-manager.widgets.viewHelper")
local beautiful = require("beautiful")

local _M = {}

-- workspace menu controller
local TaglistController = { }
TaglistController.__index = TaglistController

function TaglistController:new(workspaceManagerService, s)
    self = {}
    setmetatable(self, TaglistController)

    -- resources
    self.workspaceManagerService = workspaceManagerService
    self.screen = s
    
    -- bindings
    self.bindings = viewHelper.load_template(require("awesome-workspace-manager.widgets.taglist.template"), self)

    return self
end

-- get view 
function TaglistController:get_view_widget()
    return self.bindings.root
end

function _M.get(workspaceManagerService, s)
    return TaglistController:new(workspaceManagerService, s)
end

return setmetatable({}, { __call = function(_, workspaceManagerService, s) return _M.get(workspaceManagerService, s) end })