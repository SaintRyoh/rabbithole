local naughty = require("naughty")
local gears = require("gears")
local serpent = require("serpent")
local dbg = require("sub.debugger.debugger")
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

-- dbg.pretty dump
function debug.dumpTablePretty(tbl)
    debug.notifyDump(tbl, dbg.pretty)
end

debug.dbg = dbg
dbg.auto_where = 5
dbg.port = 9000

dbg.read = function (prompt)
     dbg.server = dbg.server or assert(socket.bind("localhost", dbg.port))
     while not dbg.client do
         dbg.client = dbg.server:accept()
     end
     dbg.client:send(prompt)
    return dbg.client:receive()
end

-- dbg.write 
dbg.write = function (str)
    dbg.server = dbg.server or assert(socket.bind("localhost", dbg.port))
    while not dbg.client do
        dbg.client = dbg.server:accept()
    end
    dbg.client:send(str)
end


return debug