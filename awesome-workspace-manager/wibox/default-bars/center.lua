local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

return setmetatable({}, {
    __constructor = function(taglist, awesome___workspace___manager__wibox__bars__center)
        return function(s)
            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            s.mylayoutbox = awful.widget.layoutbox(s)
            s.mylayoutbox:buttons(gears.table.join(
                    awful.button({ }, 1, function () awful.layout.inc( 1) end),
                    awful.button({ }, 3, function () awful.layout.inc(-1) end),
                    awful.button({ }, 4, function () awful.layout.inc( 1) end),
                    awful.button({ }, 5, function () awful.layout.inc(-1) end)
            ))
            awesome___workspace___manager__wibox__bars__center(s):setup {
                layout = wibox.layout.align.horizontal,
                taglist(s),
                s.mylayoutbox
            }
        end
    end
})