local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Pane = require("lui.Pane")
local Color = require("lui.util.Color")

local Label = utils.class(Pane)

function Label:init()
    self.text = "Label"
    self.color = Color:new()
    self.font = love.graphics.newFont()

    style.applyStyle(self, "Label")
end

function Label:widgetSetDesires()
    self:setSize(self.font:getWidth(self.text), self.font:getHeight())
end

function Label:widgetDraw()
    love.graphics.setColor(self.color:unpackRGBA())

    -- TODO: everything seems to be using the same font ref (same size when changed)?
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
        love.graphics.print(self.text, 0, 0)
    love.graphics.setFont(oldFont)

    self:drawDebugBounds()
end

return Label
