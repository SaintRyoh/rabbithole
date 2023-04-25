-- Load necessary libraries
local wibox = require("wibox")

-- Create the model table
local model = {}

-- Initialize model data
function model:init()
    self.time_format = "%d %b %Y, %H:%M"
    self.text_clock = wibox.widget.textclock(self.time_format)
end

return model