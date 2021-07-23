local utils = require("lui.util.utils")

local Pane = utils.class()

-- Constructor

function Pane:init()
    self.parent = nil

    self.x = 0
    self.y = 0
    self.width = 20
    self.height = 20

    self.marginLeft = 0
    self.marginRight = 0
    self.marginTop = 0
    self.marginBottom = 0
end

-- Basic updates

function Pane:update(dt)
    self:widgetUpdate(dt)
    self:widgetSetDesires()
    self:widgetSetReal()
end

function Pane:draw()
    love.graphics.push()
        -- Move to proper position (including margin)
        love.graphics.translate(self.x + self.marginLeft, self.y + self.marginTop)

        -- Draw layout and widget
        self:widgetDraw()
    love.graphics.pop()
end

-- Widget functions

function Pane:widgetUpdate(dt) end
function Pane:widgetDraw() self:drawDebugBounds() end
function Pane:widgetSetDesires() end
function Pane:widgetSetReal() end

-- Getter helpers

function Pane:getBounds()
    return self.x, self.y, self.width, self.height
end

function Pane:getFullBounds()
    return self.x - self.marginLeft,
           self.y - self.marginTop,
           self.width + self.marginRight + self.marginLeft,
           self.height + self.marginBottom + self.marginTop
end

-- Set helpers

function Pane:setBounds(x, y, w, h)
    self:setPosition(x, y)
    self:setSize(w, h)
    return self
end

function Pane:setPosition(x, y)
    self.x = x
    self.y = y
    return self
end

function Pane:setSize(w, h)
    self.width = w
    self.height = h
    return self
end

function Pane:setMargin(left, top, right, bottom)
    if top ~= nil and right ~= nil then
        self.marginLeft = left
        self.marginTop = top
        self.marginRight = right
        self.marginBottom = bottom
    elseif top ~= nil and right == nil then
        self:setMargin(left, top, left, top)
    else
        self:setMargin(left, left, left, left)
    end
    return self
end

-- Debug functions

function Pane:drawDebugBounds()
    -- Debug draw bounds
    if luiDebugBounds then
        local _, _, fw, fh = self:getFullBounds()
        local oldLineWidth = love.graphics.getLineWidth()
        love.graphics.setLineWidth(luiDebugLineWidth)
        love.graphics.setColor(luiMarginDebugColor:unpackRGBA())
        love.graphics.rectangle("line", 0, 0, self.width, self.height)
        love.graphics.setColor(luiDebugColor:unpackRGBA())
        love.graphics.rectangle("line", -self.marginLeft, -self.marginTop, fw,
                                fh)
        love.graphics.setLineWidth(oldLineWidth)
    end
end

-- Return class
return Pane
