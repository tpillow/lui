local utils = require("lui.util.utils")

local Color = utils.class()

function Color:init()
    self:set(1, 1, 1, 1)
end

function Color:unpackRGBA()
    return self.r, self.g, self.b, self.a
end

function Color:set(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
end

-- Static

function Color.newFromRGBA(r, g, b, a)
    local o = Color:new()
    o:set(r, g, b, a)
    return o
end

return Color
