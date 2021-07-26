local utils = require("lui.util.utils")
local style = require("lui.util.style")

local Pane = utils.class()

-- Constructor

function Pane:init()
    self.parent = nil

    self.x = 0
    self.y = 0
    self.width = 20
    self.height = 20

    self.margin = { 0, 0, 0, 0 }

    self.minWidth = 0
    self.minHeight = 0
    self.maxWidth = 2^31
    self.maxHeight = 2^31

    self.inputListeners = {}

    self.visible = true

    style.applyStyle(self, "Pane")
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
        -- Move to proper position (with margin added)
        love.graphics.translate(self.x + self:getMarginLeft(),
                                self.y + self:getMarginTop())

        -- Draw layout and widget
        self:widgetDraw()
    love.graphics.pop()
end

-- Widget functions

function Pane:widgetBuild() end
function Pane:widgetUpdate(dt) end
function Pane:widgetDraw() self:drawDebugBounds() end
function Pane:widgetSetDesires() end
function Pane:widgetSetReal() self:ensureMinMaxSize() end

-- Getter helpers

function Pane:getBounds()
    return self.x, self.y, self.width, self.height
end

function Pane:getFullBounds()
    return self.x - self:getMarginLeft(), self.y - self:getMarginTop(),
           self:getFullWidth(), self:getFullHeight()
end

function Pane:getFullWidth()
    return self.width + self:getMarginRight() + self:getMarginLeft()
end

function Pane:getFullHeight()
    return self.height + self:getMarginBottom() + self:getMarginTop()
end

function Pane:getMarginLeft() return self.margin[utils.MPIdx.Left] end
function Pane:getMarginTop() return self.margin[utils.MPIdx.Top] end
function Pane:getMarginRight() return self.margin[utils.MPIdx.Right] end
function Pane:getMarginBottom() return self.margin[utils.MPIdx.Bottom] end

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
    self.width = w - self:getMarginLeft() - self:getMarginRight()
    return self
end

function Pane:setHeightIncludesMargin(h)
    self.height = h - self:getMarginTop() - self:getMarginBottom()
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
    return self
end

function Pane:setMaxSize(w, h)
    self.maxWidth = w
    self.maxHeight = h
    return self
end

function Pane:setMinMaxSize(mw, mh, xw, xh)
    self:setMinSize(mw, mh)
    self:setMaxSize(xw, xh)
    return self
end

function Pane:setMargin(left, top, right, bottom)
    if type(left) == "table" then
        assert(#left == 4 and top == nil and right == nil and bottom == nil)
        self:setMargin(left[1], left[2], left[3], left[4])
    elseif top ~= nil and right ~= nil then
        assert(left ~= nil and bottom ~= nil)
        self.margin = { left, top, right, bottom }
    elseif top ~= nil and right == nil then
        assert(left ~= nil and bottom == nil)
        self:setMargin(left, top, left, top)
    else
        assert(left ~= nil and top == nil and right == nil and bottom == nil)
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
        love.graphics.setColor(luiDebugMarginColor:unpackRGBA())
        love.graphics.rectangle("line", 0, 0, self.width, self.height)
        love.graphics.setColor(luiDebugColor:unpackRGBA())
        love.graphics.rectangle("line", -self:getMarginLeft(), -self:getMarginTop(),
                                fw, fh)
        love.graphics.setLineWidth(oldLineWidth)
    end
end

-- Input listener helper

function Pane:addInputListener(listener)
    table.insert(self.inputListeners, listener)
end

function Pane:removeInputListener(listener)
    local idx = utils.findInList(self.inputListeners, listener)
    assert(idx > 0, "Pane:removeInputListener: could not find listener")
    table.remove(self.inputListeners, idx)
end

-- Input helpers

-- TODO: something isn't lining up globally or locally with margins/padding/stuff
function Pane:globalCoordToLocal(x, y)
    if self.parent then
        x, y = self.parent:globalCoordToLocal(x, y)
    end
    return x - self.x + self:getMarginLeft(), y - self.y + self:getMarginTop()
end

function Pane:globalCoordInBounds(x, y)
    return self:localCoordInBounds(self:globalCoordToLocal(x, y))
end

function Pane:localCoordInBounds(x, y)
    local _, _, fw, fh = self:getFullBounds()
    return x >= 0 and y >= 0 and x < fw and y < fh
end

-- Input methods

function Pane:paneMousepressed(x, y, button, istouch, presses)
    for _, child in ipairs(self.inputListeners) do
        if child:mousepressed(x, y, button, istouch, presses) then return true end
    end
    return false
end

function Pane:paneMousereleased(x, y, button, istouch, presses)
    for _, child in ipairs(self.inputListeners) do
        if child:mousereleased(x, y, button, istouch, presses) then return true end
    end
    return false
end

function Pane:paneMousemoved(x, y, dx, dy, istouch)
    for _, child in ipairs(self.inputListeners) do
        if child:mousemoved(x, y, dx, dy, istouch) then return true end
    end
    return false
end

function Pane:paneWheelmoved(x, y)
    for _, child in ipairs(self.inputListeners) do
        if child:wheelmoved(x, y) then return true end
    end
    return false
end

function Pane:paneKeypressed(key, scancode, isrepeat)
    for _, child in ipairs(self.inputListeners) do
        if child:keypressed(key, scancode, isrepeat) then return true end
    end
    return false
end

function Pane:paneKeyreleased(key, scancode)
    for _, child in ipairs(self.inputListeners) do
        if child:keyreleased(key, scancode) then return true end
    end
    return false
end

function Pane:paneTextinput(text)
    for _, child in ipairs(self.inputListeners) do
        if child:textinput(text) then return true end
    end
    return false
end

function Pane:mousepressed(x, y, button, istouch, presses)
    return self:paneMousepressed(x, y, button, istouch, presses)
end

function Pane:mousereleased(x, y, button, istouch, presses)
    return self:paneMousereleased(x, y, button, istouch, presses)
end

function Pane:mousemoved(x, y, dx, dy, istouch)
    return self:paneMousemoved(x, y, dx, dy, istouch)
end

function Pane:wheelmoved(x, y)
    return self:paneWheelmoved(x, y)
end

function Pane:keypressed(key, scancode, isrepeat)
    return self:paneKeypressed(key, scancode, isrepeat)
end

function Pane:keyreleased(key, scancode)
    return self:paneKeyreleased(key, scancode)
end

function Pane:textinput(text)
    return self:paneTextinput(text)
end

-- Return class
return Pane
