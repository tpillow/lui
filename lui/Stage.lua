local utils = require("lui.util.utils")
local Pane = require("lui.Pane")

local Stage = utils.class()

function Stage:init()
    self.children = {}
    self.active = true
end

-- Standard functions

function Stage:update(dt)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Stage:draw()
    if not self.active then return end

    for _, child in ipairs(self.children) do
        child:draw()
    end
end

-- Children functions

function Stage:addChild(child)
    assert(child and child:instanceOf(Pane))
    table.insert(self.children, child)
end

function Stage:removeChild(child)
    table.remove(self.children, utils.findInList(self.children, child))
end

return Stage
