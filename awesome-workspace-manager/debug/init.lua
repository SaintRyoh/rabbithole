local naughty = require("naughty")
local gears = require("gears")
local serpent = require("serpent")
local awful = require("awful")
local dbg = require("debugger.debugger")
local socket = require("socket")
local debug = {}

function debug.notifyDump(tbl, method)
    naughty.notify({
        title = "Debug",
        text = method(tbl),
        timeout = 0
    })
end

function debug.dumpTable(tbl)
    debug.notifyDump(tbl, gears.debug.dump_return)
end

function debug.dumpTableSerpent(tbl)
    debug.notifyDump(tbl, serpent.block)
end

function debug.startServer()
    local server = assert(socket.bind("localhost", 9000))
    local ip, port = server:getsockname()

    naughty.notify({
        preset = naughty.config.presets.normal,
        title = "Debug Server",
        text = string.format("Server started on port %d", port)
    })

    server:settimeout(nil) -- make the server blocking
    local client = server:accept()

    if client then
        -- Redirect debugger input and output to the connected client
        function dbg.read(prompt)
            client:send(prompt)
            return client:receive()
        end

        function dbg.write(str)
            client:send(str)
        end

        -- Start the debugger
        dbg()
    else
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Error",
            text = "Could not start the debugger server"
        })
    end
end

function debug.breakpoint()
    dbg()
end


return debug