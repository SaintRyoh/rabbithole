local awful = require("awful")
local wibox = require("wibox")
local config_dir = require("gears.filesystem").get_configuration_dir()

-- Create an imagebox widget
local myicon = wibox.widget.imagebox()
myicon.image = "/path/to/your/icon.png"

-- Create a button widget
local mybutton = wibox.widget {
    {
        myicon,
        margins = 4,
        widget  = wibox.container.margin,
    },
    widget = wibox.container.background,
}

-- Add mouse click event to the button
mybutton:buttons(awful.util.table.join(
    awful.button({ }, 1, function ()
        awful.spawn(config_dir .. "rabbothole/services/widgetScripts/text-to-ocr.sh")
    end)
))

-- Then add `mybutton` to your wibox in the place where you want it.
-- Here's an example of how to add it to the right side of the main wibox:
-- (assuming `right_layout` is the name of the layout used for the right side)
table.insert(right_layout, mybutton)
