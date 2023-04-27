local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

return setmetatable({}, {
    __constructor = function(awesome___workspace___manager__wibox__bars__right)
        return function(s)
            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            s.mylayoutbox = awful.widget.layoutbox(s)
            s.mylayoutbox:buttons(gears.table.join(
                    awful.button({ }, 1, function () awful.layout.inc( 1) end),
                    awful.button({ }, 3, function () awful.layout.inc(-1) end),
                    awful.button({ }, 4, function () awful.layout.inc( 1) end),
                    awful.button({ }, 5, function () awful.layout.inc(-1) end)
            ))
            awesome___workspace___manager__wibox__bars__right(s):setup {
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                wibox.widget.textclock(),
                s.mylayoutbox,
            }
        end
    end
})