local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local systrayWidget = wibox.widget.systray()

local systrayContainer = wibox.widget {
  {
      systrayWidget,
      margins = dpi(5),
      widget = wibox.container.margin,
      -- widget = wibox.widget.textbox,
      -- text = "systray",
  },
  shape = gears.shape.rounded_rect, -- add rounded corners to the widget
  shape_clip = true, -- clip the widget according to the shape
  widget = wibox.container.background,
  bg = beautiful.neutral,
}

return systrayContainer
