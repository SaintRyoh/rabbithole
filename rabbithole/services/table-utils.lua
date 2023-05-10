-- concatenates an arbitrary number of tables into the first table
-- Usage: table_utils.merge(t1, t2, t3, ...)

local table_utils = {}

function table_utils.merge(t1, ...)
    local arg = {...}   -- Capture all arguments into a table
    for _, t2 in ipairs(arg) do   -- Loop through each table in arg
        if type(t2) == 'table' then
            for k, v in pairs(t2) do
                t1[k] = v
            end
        end
    end
    return t1
end

return table_utils
