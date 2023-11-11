local awful = require("awful")

return function(opts)
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
end