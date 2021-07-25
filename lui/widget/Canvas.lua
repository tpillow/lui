local utils = require("lui.util.utils")
local Pane = require("lui.Pane")
local Color = require("lui.util.Color")

local Canvas = utils.class(Pane)

function Canvas:init()
    self.canvas = love.graphics.newCanvas(self.width, self.height)
    self.drawFunc = nil
end

function Canvas:widgetUpdate(dt)
    if self.canvas:getWidth() ~= self.width or
        self.canvas:getHeight() ~= self.height then
        self.canvas = love.graphics.newCanvas(self.width, self.height)
    end
end

function Canvas:widgetDraw()
    if self.drawFunc then
        local oldCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(self.canvas)
            self.drawFunc()
        love.graphics.setCanvas(oldCanvas)
    end
   
    love.graphics.draw(self.canvas, 0, 0, self.width, self.height)

    self:drawDebugBounds()
end

function Canvas:setDrawFunc(func) self.drawFunc = func end

return Canvas
