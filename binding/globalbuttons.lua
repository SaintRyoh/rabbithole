-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}

-- For when mouse is over the desktop
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


return setmetatable({}, {
    __constructor = function (mainmenu)
        local globalbuttons = gears.table.join(
                awful.button({ }, 3, function () mainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
        )

        root.buttons(globalbuttons)

        return globalbuttons
    end
})