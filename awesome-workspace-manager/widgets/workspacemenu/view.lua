local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

local _M = {}

-- workspace menu view
local WorkspaceMenuView = { }
WorkspaceMenuView.__index = WorkspaceMenuView
 -- 752179
function WorkspaceMenuView:new(menu, initial_text)
    self = {}
    setmetatable(self, WorkspaceMenuView)

    self.theme = beautiful.get()

    self.bindings = {}

    self.view_widget = self:build(initial_text)

    self:set_menu(menu)

    return self
end

-- build view
function WorkspaceMenuView:build(initial_text)
    self.bindings.textbox = wibox.widget {
        text = initial_text,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }


    local open_close_indicator = wibox.widget {
        image = self.theme.menu_submenu_icon,
        resize = true,
        widget = wibox.widget.imagebox
    }


    local margin = wibox.widget {
        widget = wibox.container.margin,
        margins = 3,
        open_close_indicator
    }

    self.bindings.rotator = wibox.widget {
        widget = wibox.container.rotate,
        direction = "north",
        margin
    }

    self.bindings.container = wibox.widget {
        widget = wibox.container.background,
        bg = self.theme.bg_normal,
        {
            widget = wibox.container.margin,
            margins = 3,
            {
                layout = wibox.layout.fixed.horizontal,
                self.bindings.textbox,
                self.bindings.rotator
            }
        },
    }
    self.bindings.container:connect_signal("mouse::enter", function() 
        self.bindings.container.bg = self.theme.bg_focus
    end)
    self.bindings.container:connect_signal("mouse::leave", function() 
        self.bindings.container.bg = self.theme.bg_normal 
    end)

    self.bindings.container:buttons(gears.table.join(
        awful.button({ }, 1, function(event) 
            if self.bindings.menu.wibox.visible == true then
                self.bindings.menu:hide()
            else
                self:open(event)
            end
        end)
    ))


     return self.bindings.container
end

-- open menu
function WorkspaceMenuView:open(event)
    self.bindings.rotator.direction = "west"
    self.bindings.container.bg = self.theme.bg_focus
    self.bindings.menu:show({
        coords = {
            x = event.x,
            y = event.y 
        }
    })
end

-- close menu
function WorkspaceMenuView:close()
    self.bindings.rotator.direction = "north"
    self.bindings.container.bg = self.theme.bg_normal
end

-- set text
function WorkspaceMenuView:set_text(text)
    self.bindings.textbox.text = text
end

-- get view_widget
function WorkspaceMenuView:get_view_widget()
    return self.view_widget
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
    self.bindings.menu.original_hide = self.bindings.menu.hide
    self.bindings.menu.hide = function ()
        self.bindings.menu:original_hide()
        self:close()
    end
end


function _M.get(menu, initial_text)
    return WorkspaceMenuView:new(menu, initial_text)
end

return setmetatable({}, { __call = function(_, menu, initial_text) return _M.get(menu, initial_text) end })