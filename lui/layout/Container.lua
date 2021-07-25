local utils = require("lui.util.utils")
local Pane = require("lui.Pane")

local Container = utils.class(Pane)

function Container:init()
    self:setContent(nil)
end

function Container:widgetUpdate(dt)
    self.content:widgetUpdate(dt)
end

function Container:widgetDraw()
    self.content:draw()

    self:drawDebugBounds()
end

function Container:widgetSetDesires()
    self.content:widgetSetDesires()
end

function Container:widgetSetReal()
    self:ensureMinMaxSize()

    self.content:widgetSetReal()
end

function Container:setContent(content)
    if self.content then self.content.parent = nil end
    self.content = content or Pane:new()
    self.content.parent = self
end

-- Input methods

function Container:mousepressed(x, y, button, istouch, presses)
    return self.content:mousepressed(x, y, button, istouch, presses)
end

function Container:mousereleased(x, y, button, istouch, presses)
    return self.content:mousereleased(x, y, button, istouch, presses)
end

function Container:mousemoved(x, y, dx, dy, istouch)
    return self.content:mousemoved(x, y, dx, dy, istouch)
end

function Container:wheelmoved(x, y)
    return self.content:wheelmoved(x, y)
end

function Container:keypressed(key, scancode, isrepeat)
    return self.content:keypressed(key, scancode, isrepeat)
end

function Container:keyreleased(key, scancode)
    return self.content:keyreleased(key, scancode)
end

function Container:textinput(text)
    return self.content:textinput(text)
end

return Container