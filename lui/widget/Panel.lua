local utils = require("lui.util.utils")
local style = require("lui.util.style")
local StackContainer = require("lui.layout.StackContainer")
local ColorRect = require("lui.widget.ColorRect")

local Panel = utils.class(StackContainer)

function Panel:init()
    self.backgroundColorRect = ColorRect:new()
    self.padding = { 0, 0, 0, 0 }

    self:pushChild(self.backgroundColorRect)

    style.applyStyle(self, "Panel")
end

function Panel:widgetSetDesires()
    assert(self:getChildrenCount() >= 1 and self:getChildrenCount() <= 2)

    self.width = 0
    self.height = 0

    for childIdx, child in ipairs(self.children) do
        child:widgetSetDesires()

        local padW = 0
        local padH = 0
        if childIdx == 2 then
            padW = self.padding[utils.MPIdx.Left] + self.padding[utils.MPIdx.Right]
            padH = self.padding[utils.MPIdx.Top] + self.padding[utils.MPIdx.Bottom]
        end
        
        if child:getFullWidth() + padW > self.width then
            self.width = child:getFullWidth() + padW
        end
        if child:getFullHeight() + padH > self.height then
            self.height = child:getFullHeight() + padH
        end
    end
end

function Panel:setContent(content)
    if self:getContent() then self:popChild() end
    if content then self:pushChild(content) end
end

function Panel:getContent()
    if self:getChildrenCount() > 1 then return self:peekChild() end
    return nil
end

return Panel
