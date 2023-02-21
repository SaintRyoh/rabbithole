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

    self.model = workspaceManagerService
    self.bindings = gears.table.join({
        workspaceManagerService = self.model,
        screen = s,
    })
    self.bindings = viewHelper.load_template("awesome-workspace-manager/widgets/taglist/template.lua", self.bindings)
    self.view = {
        bindings = self.bindings
    }
    return self
end


function _M.get(workspaceManagerService, s)
    return TaglistController:new(workspaceManagerService, s)
end

return setmetatable({}, { __call = function(_, workspaceManagerService, s) return _M.get(workspaceManagerService, s) end })