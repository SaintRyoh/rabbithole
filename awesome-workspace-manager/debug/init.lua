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

    server:settimeout(1) -- make the server blocking
    local client -- = server:accept()

    -- Redirect debugger input and output to the connected client
    function dbg.read(prompt)
        while not client do
            client = server:accept()
        end
        client:send(prompt)
        return client:receive()
    end

    function dbg.write(str)
        while not client do
            client = server:accept()
        end
        client:send(str)
    end

    -- Start the debugger
    -- dbg()
end

debug.breakpoint = dbg


return debug