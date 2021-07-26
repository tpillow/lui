local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Pane = require("lui.Pane")

local StackContainer = utils.class(Pane)

function StackContainer:init()
    self.children = {}

    style.applyStyle(self, "StackContainer")
end

function StackContainer:widgetBuild()
    for _, child in ipairs(self.children) do
        child:widgetBuild()
    end
end

function StackContainer:widgetUpdate(dt)
    for _, child in ipairs(self.children) do
        child:widgetUpdate(dt)
    end
end

function StackContainer:widgetDraw()
    for _, child in ipairs(self.children) do
        child:draw()
    end

    self:drawDebugBounds()
end

function StackContainer:widgetSetDesires()
    self.width = 0
    self.height = 0

    for _, child in ipairs(self.children) do
        child:widgetSetDesires()

        if child:getFullWidth() > self.width then
            self.width = child:getFullWidth()
        end
        if child:getFullHeight() > self.height then
            self.height = child:getFullHeight()
        end
    end
end

function StackContainer:widgetSetReal()
    self:ensureMinMaxSize()

    for _, child in ipairs(self.children) do
        child:setSizeIncludesMargin(self.width, self.height)
        child:widgetSetReal()
    end
end

-- StackContainer children handling

function StackContainer:getChildrenCount()
    return #self.children
end

function StackContainer:peekChild()
    assert(#self.children > 0)
    return self.children[#self.children]
end

function StackContainer:pushChild(child)
    assert(child)
    table.insert(self.children, child)
    -- TODO: input listeners should be in reverse order for this stack
    child.parent = self
    self:addInputListener(child)
    self:widgetBuild()
end

function StackContainer:popChild()
    assert(#self.children > 0)
    self:peekChild().parent = nil
    self:removeInputListener(self:peekChild())
    table.remove(self.children, #self.children)
end

return StackContainer
