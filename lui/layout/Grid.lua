local utils = require("lui.util.utils")
local Pane = require("lui.Pane")

local Grid = utils.class(Pane)

-- Constructor

function Grid:init()
    self:resetGrid()
end

-- Grid general helpers

function Grid:resetGrid()
    self.gridRows = {}
    self.gridColStarted = false
end

-- Widget functions

function Grid:widgetUpdate(dt)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            col.content:widgetUpdate(dt)
        end
    end
end

function Grid:widgetDraw()
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            col.content:draw()
        end
    end
    
    self:drawDebugBounds()
end

function Grid:widgetSetDesires()
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            col.content:widgetSetDesires()
        end
    end
end

function Grid:widgetSetReal()
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            col.content:widgetSetReal()
        end
    end
end

-- Grid helpers

function Grid:getCurGridRow()
    assert(#self.gridRows > 0)
    return self.gridRows[#self.gridRows]
end

function Grid:getCurGridCol()
    assert(self.gridColStarted)
    local curRow = self:getCurGridRow()
    return curRow.cols[#curRow.cols]
end

-- Grid row

function Grid:row()
    self.gridColStarted = false

    table.insert(self.gridRows, {
        height = "auto",
        cols = {},
    })

    return self
end

function Grid:rowHeight(spec)
    assert(#self.gridRows > 0)
    self:getCurGridRow().height = spec
    return self
end

-- Grid col

function Grid:col(content)
    assert(#self.gridRows > 0)

    self.gridColStarted = true
    table.insert(self:getCurGridRow().cols, {
        width = "auto",
        content = nil,
        hAlign = utils.HAlign.Left,
        vAlign = utils.VAlign.Top,
        hFitMode = utils.FitMode.Fit,
        vFitMode = utils.FitMode.Fit,
    })
    self:colContent(content or Pane:new())

    return self
end

function Grid:colWidth(spec)
    assert(self.gridColStarted)
    self:getCurGridCol().width = spec
    return self
end

function Grid:colContent(content)
    assert(self.gridColStarted)
    assert(content and content:instanceOf(Pane))
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
