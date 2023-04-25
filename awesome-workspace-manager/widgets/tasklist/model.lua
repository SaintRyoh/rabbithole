local _M = {}

function _M.get_clients(screen)
    local clients = {}
    for _, c in ipairs(screen:get_clients()) do
        if not (c.skip_taskbar or c.hidden or c.type == "desktop" or c.type == "dock" or c.type == "splash") then
            table.insert(clients, c)
        end
    end
    return clients
end

return _M