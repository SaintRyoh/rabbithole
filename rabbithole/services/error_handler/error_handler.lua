-- error_handler.lua
local gears = require("gears")
local naughty = require("naughty")

local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler

-- Error handling function.
local function handle_error(self, msg, notify)
    print("Error occurred: " .. tostring(msg))

    if notify then
        naughty.notification({
            title = "Awesome WM Error",
            text = tostring(msg),
            timeout = 0,
            urgency = "critical"
        })
    end

    if self.config.log_to_file then
        self:log_to_file(msg)
    end
end

-- Log error messages to a file.
function ErrorHandler:log_to_file(msg)
    local file = io.open(self.config.log_file, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. msg .. "\n")
        file:close()
    end
end

-- Initialize the error handler with the given configuration.
function ErrorHandler:init(config)
    local handler = {}
    setmetatable(handler, ErrorHandler)

    handler.config = gears.table.join({
        log_to_file = true,
        log_file = "awesome_errors.log",
        notify = true
    }, config or {})

    -- Handle runtime errors after startup.
    awesome.connect_signal("debug::error", function(err)
        handle_error(handler, "Runtime error: " .. tostring(err), handler.config.notify)
    end)

    -- Handle errors during startup.
    if awesome.startup_errors then
        handle_error(handler, "Startup error: " .. awesome.startup_errors, handler.config.notify)
    end

    -- Replacing the global error handler.
    local old_error_handler = _G.error
    _G.error = function(msg)
        handle_error(handler, "Global error: " .. tostring(msg), handler.config.notify)
        old_error_handler(msg)
    end

    return handler
end

return ErrorHandler
