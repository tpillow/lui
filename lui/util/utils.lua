local utils = {}

-- Enums

utils.DrawMode = { Outline = 1, Fill = 2, FillOutline = 3 }
utils.HAlign = { Left = 1, Center = 2, Right = 3 }
utils.VAlign = { Top = 1, Center = 2, Bottom = 3 }
utils.FitMode = { Fit = 1, Expand = 2 }

-- Math functions

function utils.clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

-- Random functions

function utils.randRGBA()
    return math.random(), math.random(), math.random(), math.random()
end

-- Class system

function utils.class(Base)
    Base = Base or utils.Object or nil
    local Class = {}
    if Base then Class = Base:new() end

    Class.Base = Base
    Class.Class = Class

    function Class:new()
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        obj:init()
        return obj
    end

    return Class
end

utils.Object = utils.class(nil)

function utils.Object:init()
end

function utils.Object:instanceOf(Class)
    local try = self.Class
    while try do
        if try == Class then return true end
        try = self.Base
    end
    return false
end

return utils
