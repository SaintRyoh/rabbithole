--[[ Class helper function in lua, can also use inheritance.
Use example:

Rectangle = class()

function Rectangle:init(width, height)
    self.width = width
    self.height = height
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:perimeter()
    return 2 * (self.width + self.height)
end

-- create an instance of the Rectangle class
rect = Rectangle(5, 10)
print(rect:area()) -- outputs: 50
print(rect:perimeter()) -- outputs: 30

]]
function class(base)
    local c = {}
    if type(base) == 'table' then
        -- new class is a shallow copy of the base class
        for i,v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end

    -- the class will be the metatable for all its objects
    c.__index = c

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj, c)
        if class_tbl.init then
            class_tbl.init(obj, ...)
        elseif base and base.init then
            -- make sure that any stuff from the base class is initialized
            base.init(obj, ...)
        end
        return obj
    end
    c.init = c.init or function() end
    setmetatable(c, mt)
    return c
end
