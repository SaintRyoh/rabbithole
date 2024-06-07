local awful = require("awful")

return function(opts)
    awful.spawn("amixer -D pulse sset Master 5%+")
end