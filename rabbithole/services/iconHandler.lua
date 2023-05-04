local iconCache = {}

local function getIcon(theme, client, programString, classString, isGitKraken)
    client = client or nil
    programString = programString or nil
    classString = classString or nil
    isGitKraken = isGitKraken or nil

    if theme and (client or programString or classString) then
        local clientName
        if isGitKraken then
            clientName = "gitkraken" .. tostring(client) .. ".svg"
        elseif client then
            if client.class then
                clientName = string.lower(client.class:gsub(" ", "")) .. ".svg"
            elseif client.name then
                clientName = string.lower(client.name:gsub(" ", "")) .. ".svg"
            else
                if client.icon then
                    return client.icon
                else
                    return "/usr/share/icons/" .. theme .. "/apps/scalable/application-default-icon.svg"
                end
            end
        else
            if programString then
                clientName = programString .. ".svg"
            else
                clientName = classString .. ".svg"
            end
        end

        for _, icon in ipairs(iconCache) do
            if icon:match(clientName) then
                return icon
            end
        end

        local iconDir = "/usr/share/icons/" .. theme .. "/apps/scalable/"
        local ioStream = io.open(iconDir .. clientName, "r")
        if ioStream ~= nil then
            iconCache[#iconCache + 1] = iconDir .. clientName
            return iconDir .. clientName
        else
            clientName = clientName:gsub("^%l", string.upper)
            ioStream = io.open(iconDir .. clientName, "r")
            if ioStream ~= nil then
                iconCache[#iconCache + 1] = iconDir .. clientName
                return iconDir .. clientName
            end
        end

        return "/usr/share/icons/" .. theme .. "/apps/scalable/application-default-icon.svg"
    end
end

return {
    getIcon = getIcon
}
