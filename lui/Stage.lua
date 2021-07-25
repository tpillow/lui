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

-- Input functions

function Stage:mousepressed(x, y, button, istouch, presses)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:mousepressed(x, y, button, istouch, presses) then return end
    end
end

function Stage:mousereleased(x, y, button, istouch, presses)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:mousereleased(x, y, button, istouch, presses) then return end
    end
end

function Stage:mousemoved(x, y, dx, dy, istouch)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:mousemoved(x, y, dx, dy, istouch) then return end
    end
end

function Stage:wheelmoved(x, y)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:wheelmoved(x, y) then return end
    end
end

function Stage:keypressed(key, scancode, isrepeat)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:keypressed(key, scancode, isrepeat) then return end
    end
end

function Stage:keyreleased(key, scancode)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:keyreleased(key, scancode) then return end
    end
end

function Stage:textinput(text)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:textinput(text) then return end
    end
end

-- Children functions

function Stage:addChild(child)
    assert(utils.instanceOf(child, Pane))
    table.insert(self.children, child)
end

function Stage:removeChild(child)
    table.remove(self.children, utils.findInList(self.children, child))
end

return Stage
