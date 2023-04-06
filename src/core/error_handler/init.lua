local ErrorHandler = require("error_handler")

-- Create an instance of the error handler and initialize it.
local error_handler = ErrorHandler:init({
    log_to_file = true,
    log_file = "awesome_errors.log",
    notify = true
})