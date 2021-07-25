local utils = require("lui.util.utils")
local Pane = require("lui.Pane")

local StackContainer = utils.class(Pane)

function StackContainer:init()
    self.children = {}
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

        if child.width > self.width then self.width = child.width end
        if child.height > self.height then self.height = child.height end
    end
end

function StackContainer:widgetSetReal()
    self:ensureMinMaxSize()

    for _, child in ipairs(self.children) do
        child:setSizeIncludesMargin(self.width, self.height)
        child:widgetSetReal()
    end
end

function StackContainer:getChildrenCount()
    return #self.children
end

function StackContainer:pushChild(child)
    assert(utils.instanceOf(child, Pane))
    table.insert(self.children, child)
    child.parent = self
end

function StackContainer:popChild()
    assert(#self.children > 0)
    table.remove(self.children, #self.children)
end

-- Input methods

function StackContainer:mousepressed(x, y, button, istouch, presses)
    for _, child in ipairs(self.children) do
        if child:mousepressed(x, y, button, istouch, presses) then return true end
    end
    return false
end

function StackContainer:mousereleased(x, y, button, istouch, presses)
    for _, child in ipairs(self.children) do
        if child:mousereleased(x, y, button, istouch, presses) then return true end
    end
    return false
end

function StackContainer:mousemoved(x, y, dx, dy, istouch)
    for _, child in ipairs(self.children) do
        if child:mousemoved(x, y, dx, dy, istouch) then return true end
    end
    return false
end

function StackContainer:wheelmoved(x, y)
    for _, child in ipairs(self.children) do
        if child:wheelmoved(x, y) then return true end
    end
    return false
end

function StackContainer:keypressed(key, scancode, isrepeat)
    for _, child in ipairs(self.children) do
        if child:keypressed(key, scancode, isrepeat) then return true end
    end
    return false
end

function StackContainer:keyreleased(key, scancode)
    for _, child in ipairs(self.children) do
        if child:keyreleased(key, scancode) then return true end
    end
    return false
end

function StackContainer:textinput(text)
    for _, child in ipairs(self.children) do
        if child:textinput(text) then return true end
    end
    return false
end

return StackContainer
