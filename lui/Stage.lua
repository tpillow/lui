local utils = require("lui.util.utils")
local Pane = require("lui.Pane")
local Window = require("lui.widget.Window")

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

-- Helpers

function Stage:moveToFront(child)
    local idx = utils.findInList(self.children, child)
    assert(idx > 0)
    table.remove(self.children, idx)
    table.insert(self.children, child)
end

function Stage:moveToBack(child)
    local idx = utils.findInList(self.children, child)
    assert(idx > 0)
    table.remove(self.children, idx)
    table.insert(self.children, 1, child)
end

-- Input functions

function Stage:mousepressed(x, y, button, istouch, presses)
    if not self.active then return end

    for _, child in ipairs(self.children) do
        if child:mousepressed(x, y, button, istouch, presses) then
            if not child.alwaysOnBottom then self:moveToFront(child) end
            return
        end
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
    assert(utils.instanceOf(child, Window))
    table.insert(self.children, child)
    -- TODO: if this property is changed, it's not updated here in the stage
    if child.alwaysOnBottom then self:moveToBack(child) end
end

function Stage:removeChild(child)
    table.remove(self.children, utils.findInList(self.children, child))
end

return Stage
