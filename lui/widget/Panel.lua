local utils = require("lui.util.utils")
local style = require("lui.util.style")
local StackContainer = require("lui.layout.StackContainer")
local Container = require("lui.layout.Container")
local Pane = require("lui.Pane")
local ColorRect = require("lui.widget.ColorRect")

local Panel = utils.class(Pane)

function Panel:init()
    self.padding = { 0, 0, 0, 0 }
    
    self.backgroundColorRect = ColorRect:new()

    self.contentContainer = Container:new()
    self.contentContainer:setChild(nil)
    
    self.stackContainer = StackContainer:new()
    self.stackContainer:pushChild(self.backgroundColorRect)
    self.stackContainer:pushChild(self.contentContainer)

    style.applyStyle(self, "Panel")
end

function Panel:widgetBuild()
    self.contentContainer:setMargin(self.padding)

    self.stackContainer:widgetBuild()
end

function Panel:widgetUpdate(dt)
    self.stackContainer:widgetUpdate(dt)
end

function Panel:widgetDraw()
    self.stackContainer:draw()

    self:drawDebugBounds()
end

function Panel:widgetSetDesires()
    self.stackContainer:widgetSetDesires()

    self.width = self.stackContainer:getFullWidth()
    self.height = self.stackContainer:getFullHeight()
end

function Panel:widgetSetReal()
    self:ensureMinMaxSize()

    self.stackContainer:setSizeIncludesMargin(self.width, self.height)
    self.stackContainer:widgetSetReal()
end

-- Panel content handlers

function Panel:setContent(content)
    self.contentContainer:setChild(content)
end

function Panel:getContent()
    return self.contentContainer:getChild()
end

return Panel
