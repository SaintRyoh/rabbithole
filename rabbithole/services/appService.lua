local awful = require("awful")
local gears = require("gears")

-- Define Application service
local appService = {}

-- Function to split string by a given character
local function split_str(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Function to parse .desktop files
function appService.get_apps()
    local apps = {}
    local dirs = { '/usr/share/applications/', '/usr/local/share/applications/' }
    for _, dir in pairs(dirs) do
        -- Open directory
        local p = io.popen('find "'..dir..'" -type f')  -- Open a file read it
        for file in p:lines() do  -- Loop through the lines in the file
            if file:match('%.desktop$') then
                local app = {}
                local desktop_entry = false
                for line in io.lines(file) do
                    if line:match('^%[Desktop Entry%]') then
                        desktop_entry = true
                    end
                    if desktop_entry then
                        if line:match('^Name=') then
                            app.name = line:gsub('^Name=', '')
                        elseif line:match('^Exec=') then
                            app.exec = line:gsub('^Exec=', ''):gsub(' %U', '')
                        elseif line:match('^Icon=') then
                            app.icon = line:gsub('^Icon=', '')
                        elseif line:match('^Categories=') then
                            app.categories = split_str(line:gsub('^Categories=', ''), ';')
                        end
                    end
                end
                if app.name and app.exec and app.categories then
                    for _, category in pairs(app.categories) do
                        if not apps[category] then apps[category] = {} end
                        table.insert(apps[category], { app.name, app.exec, app.icon })
                    end
                end
            end
        end
        p:close()
    end
    return apps
end

return appService