local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Pane = require("lui.Pane")
local Color = require("lui.util.Color")

local ColorRect = utils.class(Pane)

-- TODO: May have to override getFullWidth/Height to include line width?

function ColorRect:init()
    self.lineColor = Color:new()
    self.fillColor = Color:new()
    self.drawMode = utils.DrawMode.FillOutline
    self.lineWidth = 1
    self.cornerRadius = 0

    style.applyStyle(self, "ColorRect")
end

function ColorRect:widgetDraw()
    if self.drawMode == utils.DrawMode.Fill or
        self.drawMode == utils.DrawMode.FillOutline then
        
        love.graphics.setColor(self.fillColor:unpackRGBA())
        love.graphics.rectangle("fill", self.lineWidth / 2.0, self.lineWidth / 2.0,
                                self.width - self.lineWidth,
                                self.height - self.lineWidth, self.cornerRadius)
    end
    if self.drawMode == utils.DrawMode.Outline or
        self.drawMode == utils.DrawMode.FillOutline then
        
        love.graphics.setColor(self.lineColor:unpackRGBA())
        local oldLineWidth = love.graphics.getLineWidth()
        love.graphics.setLineWidth(self.lineWidth)
        love.graphics.rectangle("line", self.lineWidth / 2.0, self.lineWidth / 2.0,
                                self.width - self.lineWidth,
                                self.height - self.lineWidth, self.cornerRadius)
        love.graphics.setLineWidth(oldLineWidth)
    end
    
    self:drawDebugBounds()
end

return ColorRect
