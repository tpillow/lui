local utils = require("lui.util.utils")

local Color = utils.class()

function Color:init()
    self:set(1, 1, 1, 1)
end

function Color:unpackRGBA()
    return self.r, self.g, self.b, self.a
end

function Color:toTableRGBA()
    return { self.r, self.g, self.b, self.a }
end

function Color:set(r, g, b, a)
    if type(r) == "string" and utils.strStartsWith(r, "#") then
        assert(not g and not b and not a)
        r = r:sub(2)
        if string.len(r) == 6 or string.len(r) == 8 then
            self.r = tonumber(r:sub(1, 2), 16) / 255.0
            self.g = tonumber(r:sub(3, 4), 16) / 255.0
            self.b = tonumber(r:sub(5, 6), 16) / 255.0
            if string.len(r) == 8 then
                self.a = tonumber(r:sub(7, 8), 16) / 255.0
            end
        else
            assert(false, "Color:set: unknown hex color: " .. r)
        end
    elseif type(r) == "table" and utils.instanceOf(r, Color) then
        self.r = r.r
        self.g = r.g
        self.b = r.b
        self.a = r.a
    else
        assert(tonumber(r) and tonumber(g) and tonumber(b) and tonumber(a))
        self.r = tonumber(r)
        self.g = tonumber(g)
        self.b = tonumber(b)
        self.a = tonumber(a)
    end
end

-- Static

function Color.newFrom(r, g, b, a)
    local o = Color:new()
    o:set(r, g, b, a)
    return o
end

return Color
