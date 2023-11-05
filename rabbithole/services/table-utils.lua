-- concatenates an arbitrary number of tables into the first table
-- this might have been something in lodash, but I couldnt find it
-- you can use gears.table, safe to delete this file

local table_utils = {}

function table_utils.merge(t1, ...)
    local arg = {...}
    for _, t2 in ipairs(arg) do
        if type(t2) == 'table' then
            for k, v in pairs(t2) do
                t1[k] = v
            end
        end
    end
    return t1
end

return table_utils
