-- Standard awesome library
local gears = require("gears")
local awful = require("awful")


-- For when mouse is over the desktop
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return setmetatable({}, {
    __constructor = function (
        rabbithole__components__menus__main___menu
    )
        local globalbuttons = gears.table.join(
                awful.button({ }, 3, function () rabbithole__components__menus__main___menu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
        )


        return globalbuttons
    end
})