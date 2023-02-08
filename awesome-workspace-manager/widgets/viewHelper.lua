local gears = require("gears")
local __ = require("lodash")


local ViewHelper = { }

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

return ViewHelper