--[[ rabid-daemons.lua

    This file contains functions that are used to start daemons and applications.
It also is in charge of running user scripts from the rabbithole/user-scripts/ folderd.

It is called from rabbithole/services/global.lua.

This module ensures that daemons, applications, and scripts are started AFTER everything 
else and that they are started only ONCE.
]]
local awful = require("awful")
local __ = require("lodash")
local gears = require("gears")
local lfs = require("lfs")

local RabidDaemons = { }
RabidDaemons.__index = RabidDaemons

function RabidDaemons.new(settings)
    local self = setmetatable({}, RabidDaemons)

    self.settings = settings

    return self
end

function RabidDaemons:runOnce(cmd)
    -- Run pgrep, capture the output into data
    awful.spawn.easy_async_with_shell("pgrep -u $USER -f -x '" .. cmd .. "'",
        function(stdout, stderr, reason, exit_code)
            -- Only start the command if pgrep didn't find a process
            -- (i.e., if the exit code was non-zero)
            if exit_code ~= 0 then
                awful.spawn.with_shell(cmd)
            end
        end
    )
end

function RabidDaemons:runUserScripts(scripts_dir)
    -- Runs all .sh and .lua scripts in user-scripts directory.
    local scripts = scripts_dir or gears.filesystem.get_configuration_dir() .. "user-scripts"
    __.forEach(lfs.dir(scripts), function(script)
        if script ~= "." and script ~= ".." then
            local script_file = scripts .. "/" .. script
            if lfs.attributes(script_file, "mode") == "file" then
                if script_file:match("%.sh$") or script_file:match("%.lua$") then
                    self:run_once(script_file)
                end
            end
        end
    end)
end

function RabidDaemons:startDaemons(daemons)
    daemons = daemons or self.settings.daemons
    if daemons then
        __.forEach(daemons, function(daemon)
            self:runOnce(daemon)
        end)
    end
end

function RabidDaemons:startAutostartApps(apps)
    apps = apps or self.settings.autostart_apps
    if apps then
        __.forEach(apps, function(app)
            self:runOnce(app)
        end)
    end
end

return RabidDaemons