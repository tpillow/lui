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

    self.minWidth = 0
    self.minHeight = 0
    self.maxWidth = 2^31
    self.maxHeight = 2^31

    self.visible = true
end

-- Basic updates

function Pane:update(dt)
    self:widgetUpdate(dt)
    self:widgetSetDesires()
    self:widgetSetReal()
end

function Pane:draw()
    if not self.visible then return end

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
function Pane:widgetSetReal() self:ensureMinMaxSize() end

-- Getter helpers

function Pane:getBounds()
    return self.x, self.y, self.width, self.height
end

function Pane:getFullBounds()
    return self.x - self.marginLeft, self.y - self.marginTop,
           self:getFullWidth(), self:getFullHeight()
end

function Pane:getFullWidth()
    return self.width + self.marginRight + self.marginLeft
end

function Pane:getFullHeight()
    return self.height + self.marginBottom + self.marginTop
end

-- Etc helpers

function Pane:ensureMinMaxSize()
    self.width = utils.clamp(self.width, self.minWidth, self.maxWidth)
    self.height = utils.clamp(self.height, self.minHeight, self.maxHeight)
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

function Pane:setWidthIncludesMargin(w)
    self.width = w - self.marginLeft - self.marginRight
    return self
end

function Pane:setHeightIncludesMargin(h)
    self.height = h - self.marginTop - self.marginBottom
    return self
end

function Pane:setSizeIncludesMargin(w, h)
    self:setWidthIncludesMargin(w)
    self:setHeightIncludesMargin(h)
    return self
end

function Pane:setMinSize(w, h)
    self.minWidth = w
    self.minHeight = h
end

function Pane:setMaxSize(w, h)
    self.maxWidth = w
    self.maxHeight = h
end

function Pane:setMinMaxSize(mw, mh, xw, xh)
    self:setMinSize(mw, mh)
    self:setMaxSize(xw, xh)
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

-- Input helpers

function Pane:globalCoordToLocal(x, y)
    if self.parent then
        x, y = self.parent:globalCoordToLocal(x, y)
    end
    return x - self.x + self.marginLeft, y - self.y + self.marginTop
end

function Pane:globalCoordInBounds(x, y)
    return self:localCoordInBounds(self:globalCoordToLocal(x, y))
end

function Pane:localCoordInBounds(x, y)
    local _, _, fw, fh = self:getBounds()
    return x >= 0 and y >= 0 and x < fw and y < fh
end

-- Input methods

function Pane:mousepressed(x, y, button, istouch, presses)
    return false
end

function Pane:mousereleased(x, y, button, istouch, presses)
    return false
end

function Pane:mousemoved(x, y, dx, dy, istouch)
    return false
end

function Pane:wheelmoved(x, y)
    return false
end

function Pane:keypressed(key, scancode, isrepeat)
    return false
end

function Pane:keyreleased(key, scancode)
    return false
end

function Pane:textinput(text)
    return false
end

-- Return class
return Pane
