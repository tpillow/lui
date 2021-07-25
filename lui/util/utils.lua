local utils = {}

-- Enums

utils.DrawMode = { Outline = 1, Fill = 2, FillOutline = 3 }
utils.HAlign = { Left = 1, Center = 2, Right = 3 }
utils.VAlign = { Top = 1, Center = 2, Bottom = 3 }
utils.FitMode = { Fit = 1, Expand = 2 }

-- Size spec functions

function utils.computeSizeSpec(spec, autoSize, totalWeight, extraSpace)
    local ret = -1
    utils.switchSizeSpec(spec,
        function()
            ret = autoSize
        end,
        function(weight)
            local weight = utils.getSizeSpecWeight(spec)
            ret = (weight / totalWeight) * extraSpace
        end,
        function(pixels)
            ret = pixels
        end)
    assert(ret >= 0, "utils.computeSizeSpec: return computation must be >= 0")
    return ret
end

function utils.switchSizeSpec(spec, autoHandler, weightHandler, pixelHandler)
    assert(spec and autoHandler and weightHandler and pixelHandler)
    if utils.isAutoSizeSpec(spec) then
        autoHandler()
    elseif utils.isWeightSizeSpec(spec) then
        weightHandler(utils.getSizeSpecWeight(spec))
    elseif utils.isPixelSizeSpec(spec) then
        pixelHandler(utils.getSizeSpecPixel(spec))
    else
        assert(false, "utils.switchSizeSpec: unparseable size spec: " .. spec)
    end
end

function utils.isAutoSizeSpec(spec)
    return type(spec) == "string" and string.lower(spec) == "auto"
end

function utils.isWeightSizeSpec(spec)
    return type(spec) == "string" and utils.strEndsWith(spec, "*") and
           tonumber(spec:sub(1, -2)) ~= nil
end

function utils.isPixelSizeSpec(spec) return tonumber(spec) ~= nil end

function utils.getSizeSpecWeight(spec)
    assert(utils.isWeightSizeSpec(spec))
    return tonumber(spec:sub(1, -2))
end

function utils.getSizeSpecPixel(spec)
    assert(utils.isPixelSizeSpec(spec))
    return tonumber(spec)
end

-- Object extension functions

function utils.strEndsWith(str, suffix)
    return str:sub(-string.len(suffix)) == suffix
end

function utils.findInList(list, value)
    for idx, test in ipairs(list) do
        if test == value then return idx end
    end
    return -1
end

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

    Class.Class = Class
    Class.Base = Base

    function Class:new()
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        obj.Class = Class
        obj.Base = Base
        obj:init()
        return obj
    end

    return Class
end

utils.Object = utils.class(nil)

function utils.Object:init()
end

function utils.instanceOf(obj, Class)
    if obj == nil or Class == nil then return false end
    if obj.Class == Class then return true end
    if obj.Base then return utils.instanceOf(obj.Base, Class) end
    return false
end

return utils
