--[[ rabid-daemons.lua

    This file contains functions that are used to start daemons and
applications. It is called from rabbithole/services/global.lua.
This ensures that the daemons and applications are started after everything 
else and that they are started only once.
]]
local awful require("awful")
local __ = require("lodash")


return setmetatable({ }, {
    __constructor = function (
        settings
    )
        -- Run a command only if it is not already running
        local function run_once(cmd)
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

        -- Spawn clients in the daemons settings
        if settings.daemons then
            __.forEach(settings.daemons, function(daemon)
                run_once(daemon)
            end)
        end

        -- Autostart applications
        if settings.autostart_apps then
            __.forEach(settings.autostart_apps, function(app)
                run_once(app)
            end)
        end
    end
})
