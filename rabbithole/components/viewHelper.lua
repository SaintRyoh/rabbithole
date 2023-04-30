local gears = require("gears")
local __ = require("lodash")
local serpent = require("serpent")
local naughty = require("naughty")

-- might rename this to "Tubular"

local ViewHelper = { }


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

return ViewHelper