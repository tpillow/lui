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

-- Container child methods

function Container:setChild(child)
    if self.child then
        self.child.parent = nil
        self:removeInputListener(self.child)
    end
    self.child = child or Pane:new()
    self.child.parent = self
    self:addInputListener(self.child)
    self:widgetBuild()
end

function Container:getChild()
    return self.child
end

return Container
