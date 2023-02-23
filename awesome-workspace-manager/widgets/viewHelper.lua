local gears = require("gears")
local __ = require("lodash")
local serpent = require("serpent")
local naughty = require("naughty")

-- might rename this to "Tubular"

local ViewHelper = { }

-- Usage example
-- self.bindings = ViewHelper.build_bindings_from_widget(widget)

-- recursive function to build a flat array of bindings
-- { bind = widget, bind2 = widget2, ...}
function ViewHelper.build_bindings_from_widget(widget)
    return __.reduce(widget:get_children(), function(result, child)
        return gears.table.join(result, ViewHelper.build_bindings_from_widget(child))
    end, ViewHelper.check_widget_for_bind(widget))
end

-- check if a widget has a "bind" property if so
-- return { bind = widget}
function ViewHelper.check_widget_for_bind(widget)
    if widget.bind ~= nil then
        return { [widget.bind] = widget }
    else
        return {}
    end
end

-- recursively connect signals to a widget
-- inputs:
-- * widget: the widget to connect the signals to
-- do I need to disconnect these signals? or do they get garbage collected?
function ViewHelper.connect_signals(widget, bindings)
    if widget.signals ~= nil then
        for signal, callback in pairs(widget.signals) do
            widget:connect_signal(signal, function (...)
                callback(widget, bindings, ...)
            end)
        end
    end
    for _, child in pairs(widget:get_children()) do
        ViewHelper.connect_signals(child)
    end
end

-- recursively connect buttons to a widget
-- inputs:
-- * widget: the widget to connect the buttons to
function ViewHelper.connect_buttons(widget, bindings)
    if widget.t_buttons ~= nil then

        -- build a table of buttons
        local buttons = {}
        for _, button in pairs(widget.t_buttons) do
            if type(button) == "function" then
                table.insert(buttons, button(widget, bindings))
            else
                table.insert(buttons, button)
            end
        end

        -- connect the buttons
        if #buttons > 0 then
            widget:buttons(gears.table.join(table.unpack(buttons)))
        end
    end
    for _, child in pairs(widget:get_children()) do
        ViewHelper.connect_buttons(child)
    end
end

-- Sometimes you want to decorate a method with some code before and after the method
-- for example you might want to change the background color of a widget before and after
-- a method is called.
-- Example:
-- myWidget.method = ViewHelper.decorate_method(myWidget.method, function()
--     print("before")
-- end, function()
--     print("after")
-- end)
function ViewHelper.decorate_method(method, before, after)
    return function(...)
        if before ~= nil then
            before(...)
        end
        method(...)
        if after ~= nil then
            after(...)
        end
    end
end

-- load a template from a file
-- inputs: 
-- * template_path: path to the template file
-- outputs:
-- * bindings: a table of bindings to the widgets in the template
--
-- the contents of the template file should look like this:
-- local wibox = require("wibox")
-- local beautiful = require("beautiful")
-- local __ = require("lodash")
-- 
-- local Template = { }
--
-- Template.root = wibox.widget {
--     widget = wibox.container.background,
--     bg = beautiful.bg_normal,
--     bind = "root",
--     signals = {
--         ["mouse::enter"] = function(widget, bindings)
--             widget.bg = beautiful.bg_focus
--         end,

--         ["mouse::leave"] = function(widget, bindings)
--             widget.bg = beautiful.bg_normal
--         end
--     },
--     t_buttons = {
--         function(widget, bindings)
--             return awful.button({ }, 1, function(event) 
--                 if bindings.menu.wibox.visible == true then
--                     bindings.menu:hide()
--                 else
--                     bindings.rotator.direction = "west"
--                     bindings.root.bg = beautiful.bg_focus
--                     bindings.menu:show({
--                         coords = {
--                             x = event.x,
--                             y = event.y 
--                         }
--                     })
--                 end
--             end)
--         end
--     },
--     {
--         widget = wibox.container.margin,
--         margins = 3,
--         {
--             layout = wibox.layout.fixed.horizontal,
--             {
--                 text = "initial text",
--                 align = "center",
--                 valign = "center",
--                 widget = wibox.widget.textbox,
--                 bind = "textbox"
--             },
--             {
--                 widget = wibox.container.rotate,
--                 direction = "north",
--                 {
--                     widget = wibox.container.margin,
--                     margins = 3,
--                     {
--                         image = beautiful.menu_submenu_icon,
--                         resize = true,
--                         widget = wibox.widget.imagebox,
--                         bind = "open_close_indicator"
--                     }
--                 },
--                 bind = "rotator"
--             }
--         }
--     },
-- }
function ViewHelper.load_template(template, controller)

    -- load the template file
    local template = template(controller)

    -- build bindings
    local bindings = ViewHelper.build_bindings_from_widget(template.root)
    bindings = gears.table.join(bindings, controller)

    -- connect signals
    ViewHelper.connect_signals(template.root, bindings)

    -- connect buttons
    ViewHelper.connect_buttons(template.root, bindings)

    return bindings

end

return ViewHelper