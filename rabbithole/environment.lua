-- Environments are made out of systems and UIs

local Environment = {}
Environment.__index = Environment

function Environment.new(
    rabbithole__ui__default, 
    rabbithole__services__global,
    rabbithole__services__sloppy___focus
)
    local self = setmetatable({}, Environment)

    return self
end

return Environment