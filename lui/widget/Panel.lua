local utils = require("lui.util.utils")
local style = require("lui.util.style")
local StackContainer = require("lui.layout.StackContainer")
local ColorRect = require("lui.widget.ColorRect")

local Panel = utils.class(StackContainer)

function Panel:init()
    self.backgroundColorRect = ColorRect:new()

    self:pushChild(self.backgroundColorRect)

    style.applyStyle(self, "Panel")
end

function setContent(content)
    if self:getContent() then self:popChild() end
    if content then self:pushChild(content) end
end

function getContent()
    if self:getChildrenCount() > 1 then return self:peekChild() end
    return nil
end

return Panel
