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

    self:build()

    self:set_menu(menu)

    return self
end

-- build view
-- * load template
-- * connect signals
function WorkspaceMenuView:build()

    -- Load Template 
    self:load_template("awesome-workspace-manager/widgets/workspacemenu/template.lua")

    -- connect signals
    self.bindings.root:connect_signal("mouse::enter", function() 
        self.bindings.root.bg = self.theme.bg_focus
    end)
    self.bindings.root:connect_signal("mouse::leave", function() 
        self.bindings.root.bg = self.theme.bg_normal 
    end)

    self.bindings.root:buttons(gears.table.join(
        awful.button({ }, 1, function(event) 
            if self.bindings.menu.wibox.visible == true then
                self.bindings.menu:hide()
            else
                self:open(event)
            end
        end)
    ))


end

-- load template
function WorkspaceMenuView:load_template(template_path)
    self.bindings = gears.table.join(self.bindings, viewHelper.load_template(template_path))
end

-- open menu
function WorkspaceMenuView:open(event)
    self.bindings.rotator.direction = "west"
    self.bindings.root.bg = self.theme.bg_focus
    self.bindings.menu:show({
        coords = {
            x = event.x,
            y = event.y 
        }
    })
end

-- get view_widget
function WorkspaceMenuView:get_view_widget()
    return self.bindings.root
end

-- close menu
function WorkspaceMenuView:close()
    self.bindings.rotator.direction = "north"
    self.bindings.root.bg = self.theme.bg_normal
end

-- set text
function WorkspaceMenuView:set_text(text)
    self.bindings.textbox.text = text
end

-- toggle menu
function WorkspaceMenuView:toggle_menu()
end

-- set menu
function WorkspaceMenuView:set_menu(menu)
    if self.bindings.menu ~= nil then
        self.bindings.menu:hide()
    end
    self.bindings.menu = menu
    -- decorate menu hide method
    self.bindings.menu.hide = viewHelper.decorate_method(self.bindings.menu.hide, function() self:close() end)
end


function _M.get(menu, initial_text)
    return WorkspaceMenuView:new(menu, initial_text)
end

return setmetatable({}, { __call = function(_, menu, initial_text) return _M.get(menu, initial_text) end })