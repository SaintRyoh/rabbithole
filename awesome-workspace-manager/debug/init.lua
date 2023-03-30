local naughty = require("naughty")
local gears = require("gears")
local serpent = require("serpent")
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

return debug