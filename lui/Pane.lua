local utils = require("lui.util.utils")

local Pane = utils.class()

-- Constructor

function Pane:init()
    self.parent = nil

    self.x = 0
    self.y = 0
    self.width = 20
    self.height = 20

    self.marginLeft = 5
    self.marginRight = 5
    self.marginTop = 5
    self.marginBottom = 5

    self:resetLayout()
end

-- Basic updates

function Pane:update(dt)
    self:layoutUpdate(dt)
    self:widgetUpdate(dt)

    self:layoutSetDesires()
    self:widgetSetDesires()

    self:layoutSetReal()
    self:widgetSetReal()
end

function Pane:draw()
    love.graphics.push()
        -- Move to proper position (including margin)
        local fx, fy, fw, fh = self:getFullBounds()
        love.graphics.translate(fx + self.marginLeft, fy + self.marginTop)

        -- Debug draw bounds
        if luiDebugBounds then
            local oldLineWidth = love.graphics.getLineWidth()
            love.graphics.setLineWidth(luiDebugLineWidth)
            love.graphics.setColor(luiDebugColor:unpackRGBA())
            love.graphics.rectangle("line", -self.marginLeft, -self.marginTop, fw,
                                    fh)
            love.graphics.setColor(luiMarginDebugColor:unpackRGBA())
            love.graphics.rectangle("line", 0, 0, self.width, self.height)
            love.graphics.setLineWidth(oldLineWidth)
        end

        -- Draw layout and widget
        self:layoutDraw()
        self:widgetDraw()
    love.graphics.pop()
end

-- Base layout functions

function Pane:layoutUpdate(dt)
    if self.layoutMode == utils.LayoutMode.NotSet then return end
    if self.layoutMode == utils.LayoutMode.Grid then
        for _, row in ipairs(self.gridRows) do
            for _, col in ipairs(row.cols) do
                col.content:update(dt)
            end
        end
    else
        assert(false, "unknown layoutMode " .. self.layoutMode)
    end
end

function Pane:layoutDraw()
    if self.layoutMode == utils.LayoutMode.NotSet then return end
    if self.layoutMode == utils.LayoutMode.Grid then
        for _, row in ipairs(self.gridRows) do
            for _, col in ipairs(row.cols) do
            
            end
        end
    else
        assert(false, "unknown layoutMode " .. self.layoutMode)
    end
end

function Pane:layoutSetDesires()
    if self.layoutMode == utils.LayoutMode.NotSet then return end
    if self.layoutMode == utils.LayoutMode.Grid then
        for _, row in ipairs(self.gridRows) do
            for _, col in ipairs(row.cols) do
            
            end
        end
    else
        assert(false, "unknown layoutMode " .. self.layoutMode)
    end
end

function Pane:layoutSetReal()
    if self.layoutMode == utils.LayoutMode.NotSet then return end
    if self.layoutMode == utils.LayoutMode.Grid then
        for _, row in ipairs(self.gridRows) do
            for _, col in ipairs(row.cols) do
            
            end
        end
    else
        assert(false, "unknown layoutMode " .. self.layoutMode)
    end
end

function Pane:resetLayout()
    self.layoutMode = utils.LayoutMode.NotSet
    self.gridRows = nil
    self.gridColStarted = false
end

-- Grid functionality

-- Grid helpers

function Pane:getCurGridRow()
    assert(self.layoutMode == utils.LayoutMode.Grid)
    return self.gridRows[#self.gridRows]
end

function Pane:getCurGridCol()
    assert(self.gridColStarted)
    return self:getCurGridRow().cols[#self:getCurGridRow().cols]
end

function Pane:row()
    -- Checks
    assert(self.layoutMode == utils.LayoutMode.Grid or self.layoutMode == utils.LayoutMode.NotSet)
    if self.layoutMode == utils.LayoutMode.NotSet then
        self.layoutMode = utils.LayoutMode.Grid
        self.gridRows = {}
    end
    self.gridColStarted = false

    -- Create a new row
    table.insert(self.gridRows, {
        height = "auto",
        cols = {},
    })

    return self
end

function Pane:rowHeight(spec)
    assert(self.layoutMode == utils.LayoutMode.Grid)
    self:getCurGridRow().height = spec
    return self
end

function Pane:col()
    -- Checks
    assert(self.layoutMode == utils.LayoutMode.Grid)

    -- Create column
    self.gridColStarted = true
    table.insert(self.gridRows[#self.gridRows].cols, {
        width = "auto",
        content = nil,
        hAlign = utils.HAlign.Left,
        vAlign = utils.VAlign.Top,
        hFitMode = utils.FitMode.Fit,
        vFitMode = utils.FitMode.Fit,
    })

    return self
end

function Pane:colWidth(spec)
    assert(self.gridColStarted)
    self:getCurGridCol().width = spec
    return self
end

function Pane:colContent(content)
    assert(self.gridColStarted)
    assert(content:instanceOf(Pane))
    self:getCurGridCol().content = content
    content.parent = self
    return self
end

function Pane:colHAlign(align)
    assert(self.gridColStarted)
    self:getCurGridCol().hAlgin = align
    return self
end

function Pane:colVAlign(align)
    assert(self.gridColStarted)
    self:getCurGridCol().vAlgin = align
    return self
end

function Pane:colHFitMode(mode)
    assert(self.gridColStarted)
    self:getCurGridCol().hFitMode = mode
    return self
end

function Pane:colVFitMode(mode)
    assert(self.gridColStarted)
    self:getCurGridCol().vFitMode = mode
    return self
end

-- Widget functions

function Pane:widgetUpdate(dt) end
function Pane:widgetDraw() end
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
    self.marginLeft = left
    self.marginTop = top
    self.marginRight = right
    self.marginBottom = bottom
    return self
end

-- Return class
return Pane
