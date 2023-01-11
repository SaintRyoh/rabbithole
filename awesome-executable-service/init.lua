local ExecutableService = {}

function ExecutableService.isExecutableExist(executable)
    local handle = io.popen("which " .. executable)
    local result = handle:read("*a")
    handle:close()
    if result == "" then
        return false, "Error: Executable not found"
    else
        return true
    end
end

function ExecutableService.getExecutableNameByPid(pid)
    local handle = io.popen("readlink -f /proc/" .. pid .. "/exe | cut -d' ' -f1")
    if not handle then
        return nil, "Failed to open process"
    end
    local result = handle:read("*a")
    if result == "" then
        return nil, "Process does not exist"
    end
    handle:close()
    return result:gsub("%s+$", "")
end

function ExecutableService.getProcessArgs(pid)
    local handle = io.popen("cat /proc/" .. pid .. "/cmdline")
    local result = handle:read("*a")
    handle:close()
    return result
end

function ExecutableService.isProcessRunning(pid)
    local handle = io.popen("ps -p " .. pid)
    local result = handle:read("*a")
    handle:close()
    if result:match("%d+") then
        return true
    else
        return false
    end
end

function ExecutableService.getParentPid(pid)
    local handle = io.popen("cat /proc/" .. pid .. "/stat | awk '{print $4}'")
    local result = handle:read("*a")
    handle:close()
    return tonumber(result)
end

function ExecutableService.getPidByName(name)
    local handle = io.popen("pidof " .. name)
    local result = handle:read("*a")
    handle:close()
    return tonumber(result)
end

function ExecutableService.getProcessStatus(pid)
    local handle = io.popen("ps -p " .. pid .. " -o state=")
    local result = handle:read("*a")
    handle:close()
    return result
end

return ExecutableService
