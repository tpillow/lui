local utils = require("lui.util.utils")
local style = require("lui.util.style")
local StackContainer = require("lui.layout.StackContainer")
local Container = require("lui.layout.Container")
local ColorRect = require("lui.widget.ColorRect")

local Panel = utils.class(Container)

function Panel:init()
    self.padding = { 0, 0, 0, 0 }
    
    self.backgroundColorRect = ColorRect:new()

    self.contentContainer = Container:new()
    self.contentContainer:setChild(nil)
    
    self.stackContainer = StackContainer:new()
    self.stackContainer:pushChild(self.backgroundColorRect)
    self.stackContainer:pushChild(self.contentContainer)
    self:setChild(self.stackContainer)

    style.applyStyle(self, "Panel")
end

local superWidgetBuild = Panel.widgetBuild
function Panel:widgetBuild()
    self.contentContainer:setMargin(self.padding)

    superWidgetBuild(self)
end

function Panel:setContent(content)
    self.contentContainer:setChild(content)
end

function Panel:getContent()
    return self.contentContainer:getChild()
end

return Panel
