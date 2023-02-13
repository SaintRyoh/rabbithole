local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local viewHelper = require("awesome-workspace-manager.widgets.viewHelper")

local _M = {}

-- workspace menu view
local WorkspaceMenuView = { }
WorkspaceMenuView.__index = WorkspaceMenuView
 -- 752179
function WorkspaceMenuView:new(menu)
    self = {}
    setmetatable(self, WorkspaceMenuView)

    self.theme = beautiful.get()

    self.bindings = {}
    self:load_template("awesome-workspace-manager/widgets/workspacemenu/template.lua")
    self:set_menu(menu)

    return self
end

-- load template
function WorkspaceMenuView:load_template(template_path)
    self.bindings = viewHelper.load_template(template_path, self.bindings)
end


-- get view_widget
function WorkspaceMenuView:get_view_widget()
    return self.bindings.root
end

-- set text
function WorkspaceMenuView:set_text(text)
    self.bindings.textbox.text = text
end


-- set menu
function WorkspaceMenuView:set_menu(menu)
    if self.bindings.menu ~= nil then
        self.bindings.menu:hide()
    end

    self.bindings.menu = menu

    self.bindings.menu.hide = viewHelper.decorate_method(self.bindings.menu.hide, function() 
        self.bindings.rotator.direction = "north"
        self.bindings.root.bg = self.theme.bg_normal
    end)
end


function _M.get(menu)
    return WorkspaceMenuView:new(menu)
end

return setmetatable({}, { __call = function(_, menu) return _M.get(menu) end })