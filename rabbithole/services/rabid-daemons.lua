--[[ 
    This file contains functions that are used to start daemons and
applications. It is called from rabbithole/services/global.lua.
This ensures that the daemons and applications are started after everything 
else and that they are started only once.
]]
local awful require("awful")

-- Run a command only if it is not already running
function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    -- Run pgrep, capture the output into data
    awful.spawn.with_line_callback("pgrep -u $USER -x " .. findme,
        {
            stdout = function(line)
                if line == '' then
                    awful.spawn.with_shell(cmd)
                end
            end
        }
    )
end
