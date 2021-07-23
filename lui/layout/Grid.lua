local utils = require("lui.util.utils")
local Pane = require("lui.Pane")

local Grid = utils.class(Pane)

-- Constructor

function Grid:init()
    self:resetGrid()
end

-- Grid general helpers

function Grid:resetGrid()
    self.layoutMode = utils.LayoutMode.NotSet
    self.gridRows = nil
    self.gridColStarted = false
end

-- Widget functions

function Grid:widgetUpdate(dt)
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

function Grid:widgetDraw()
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

function Grid:widgetSetDesires()
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

function Grid:widgetSetReal()
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

-- Grid helpers

function Grid:getCurGridRow()
    assert(self.layoutMode == utils.LayoutMode.Grid)
    return self.gridRows[#self.gridRows]
end

function Grid:getCurGridCol()
    assert(self.gridColStarted)
    return self:getCurGridRow().cols[#self:getCurGridRow().cols]
end

-- Grid row

function Grid:row()
    -- Checks
    assert(self.layoutMode == utils.LayoutMode.Grid or
           self.layoutMode == utils.LayoutMode.NotSet)
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

function Grid:rowHeight(spec)
    assert(self.layoutMode == utils.LayoutMode.Grid)
    self:getCurGridRow().height = spec
    return self
end

-- Grid col

function Grid:col()
    -- Checks
    assert(self.layoutMode == utils.LayoutMode.Grid)

    -- Create column
    self.gridColStarted = true
    table.insert(self:getCurGridRow().cols, {
        width = "auto",
        content = nil,
        hAlign = utils.HAlign.Left,
        vAlign = utils.VAlign.Top,
        hFitMode = utils.FitMode.Fit,
        vFitMode = utils.FitMode.Fit,
    })

    return self
end

function Grid:colWidth(spec)
    assert(self.gridColStarted)
    self:getCurGridCol().width = spec
    return self
end

function Grid:colContent(content)
    assert(self.gridColStarted)
    assert(content:instanceOf(Pane))
    self:getCurGridCol().content = content
    content.parent = self
    return self
end

function Grid:colHAlign(align)
    assert(self.gridColStarted)
    self:getCurGridCol().hAlgin = align
    return self
end

function Grid:colVAlign(align)
    assert(self.gridColStarted)
    self:getCurGridCol().vAlgin = align
    return self
end

function Grid:colHFitMode(mode)
    assert(self.gridColStarted)
    self:getCurGridCol().hFitMode = mode
    return self
end

function Grid:colVFitMode(mode)
    assert(self.gridColStarted)
    self:getCurGridCol().vFitMode = mode
    return self
end

return Grid
