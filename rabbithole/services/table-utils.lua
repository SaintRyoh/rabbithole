local table_utils = {}

function table_utils.merge(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

return table_utils