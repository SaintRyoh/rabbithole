--
-- Grab Environment that we need
local setmetatable = setmetatable

-- Class
local workspace_manager = { 
    prop = 0,
    workspaces = {}
}

function workspace_manager:new(prop)
    o = {}
    setmetatable(o, self)
    self.__index = self
    
    -- properties
    self.prop = prop

    return o
end

function workspace_manager:printProp()
    print(self.prop)
end

function workspace_manager:add(workspace) 
    table.insert(self.workspaces, workspace)
end


mywm = workspace_manager:new(5)

mywm:printProp()
