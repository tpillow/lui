local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Pane = require("lui.Pane")

local Container = utils.class(Pane)

function Container:init()
    self.containerDoSelfSetDesires = true
   
    self:setChild(nil)
    
    style.applyStyle(self, "Container")
end

function Container:widgetBuild()
    self.child:widgetBuild()
end

function Container:widgetUpdate(dt)
    self.child:widgetUpdate(dt)
end

function Container:widgetDraw()
    self.child:draw()

    self:drawDebugBounds()
end

function Container:widgetSetDesires()
    self.child:widgetSetDesires()

    if self.containerDoSelfSetDesires then
        self.width = self.child:getFullWidth()
        self.height = self.child:getFullHeight()
    end
end

function Container:widgetSetReal()
    self:ensureMinMaxSize()

    self.child:setSizeIncludesMargin(self.width, self.height)
    self.child:widgetSetReal()
end

function Container:setChild(child)
    if self.child then self.child.parent = nil end
    self.child = child or Pane:new()
    assert(utils.instanceOf(self.child, Pane))
    self.child.parent = self
    self:widgetBuild()
end

function Container:getChild(child)
    return self.child
end

-- Input methods

function Container:mousepressed(x, y, button, istouch, presses)
    return self.child:mousepressed(x, y, button, istouch, presses)
end

function Container:mousereleased(x, y, button, istouch, presses)
    return self.child:mousereleased(x, y, button, istouch, presses)
end

function Container:mousemoved(x, y, dx, dy, istouch)
    return self.child:mousemoved(x, y, dx, dy, istouch)
end

function Container:wheelmoved(x, y)
    return self.child:wheelmoved(x, y)
end

function Container:keypressed(key, scancode, isrepeat)
    return self.child:keypressed(key, scancode, isrepeat)
end

function Container:keyreleased(key, scancode)
    return self.child:keyreleased(key, scancode)
end

function Container:textinput(text)
    return self.child:textinput(text)
end

return Container
