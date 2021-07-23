local utils = require("lui.util.utils")
local Pane = require("lui.Pane")
local Color = require("lui.util.Color")

local ColorRect = utils.class(Pane)

function ColorRect:init()
    self.lineColor = Color:new()
    self.fillColor = Color:new()
    self.drawMode = utils.DrawMode.FillOutline
    self.lineWidth = 1
end

function ColorRect:widgetDraw()
    if self.drawMode == utils.DrawMode.Fill or self.drawMode == utils.DrawMode.FillOutline then
        love.graphics.setColor(self.fillColor:unpackRGBA())
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    end
    if self.drawMode == utils.DrawMode.Outline or self.drawMode == utils.DrawMode.FillOutline then
        love.graphics.setColor(self.lineColor:unpackRGBA())
        local oldLineWidth = love.graphics.getLineWidth()
        love.graphics.setLineWidth(self.lineWidth)
        love.graphics.rectangle("line", 0, 0, self.width, self.height)
        love.graphics.setLineWidth(oldLineWidth)
    end
end

return ColorRect
