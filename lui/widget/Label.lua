local utils = require("lui.util.utils")
local Pane = require("lui.Pane")
local Color = require("lui.util.Color")

local Label = utils.class(Pane)

function Label:init()
    self.text = "Label"
    self.color = Color:new()
end

function Label:widgetSetDesires()
    local font = love.graphics.getFont()
    self:setSize(font:getWidth(self.text), font:getHeight())
end

function Label:widgetDraw()
    love.graphics.setColor(self.color:unpackRGBA())
    love.graphics.print(self.text, 0, 0)

    self:drawDebugBounds()
end

return Label
