local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Pane = require("lui.Pane")

local Grid = utils.class(Pane)

-- Constructor

function Grid:init()
    self:reset()

    style.applyStyle(self, "Grid")
end

-- Grid general helpers

function Grid:reset()
    self.gridRows = {}
    self.gridColStarted = false
end

-- Widget functions

function Grid:widgetBuild()
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            col.content:widgetBuild()
        end
    end
end

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
    
    local desiredWidth = 0
    local desiredHeight = 0

    for _, row in ipairs(self.gridRows) do
        row.desiredWidth = 0
        row.desiredHeight = 0

        for _, col in ipairs(row.cols) do
            utils.switchSizeSpec(col.width,
                function()
                    row.desiredWidth = row.desiredWidth + col.content:getFullWidth()
                end,
                function(weight)
                end,
                function(pixels)
                    row.desiredWidth = row.desiredWidth + pixels
                end)

            if col.content:getFullHeight() > row.desiredHeight then
                row.desiredHeight = col.content:getFullHeight()
            end
        end
            
        utils.switchSizeSpec(row.height,
            function() -- Auto is handled/added up above
            end,
            function(weight)
                row.desiredHeight = 0
            end,
            function(pixels)
                row.desiredHeight = pixels
            end)
        
        if row.desiredWidth > desiredWidth then desiredWidth = row.desiredWidth end
        desiredHeight = desiredHeight + row.desiredHeight
    end

    -- Set our desires
    self.width = desiredWidth
    self.height = desiredHeight
end

function Grid:widgetSetReal()
    self:ensureMinMaxSize()
    
    local widthWeightTotalList = {}
    local allocatedWidthList = {}
    local heightWeightTotal = 0
    local allocatedHeight = 0

    for _, row in ipairs(self.gridRows) do
        local widthWeightTotal = 0
        local allocatedWidth = 0
        local largestColHeight = 0

        for _, col in ipairs(row.cols) do
            utils.switchSizeSpec(col.width,
                function()
                    allocatedWidth = allocatedWidth + col.content:getFullWidth()
                end,
                function(weight)
                    widthWeightTotal = widthWeightTotal + weight
                end,
                function(pixels)
                    allocatedWidth = allocatedWidth + pixels
                end)
            
            if col.content:getFullHeight() > largestColHeight then
                largestColHeight = col.content:getFullHeight()
            end
        end

        utils.switchSizeSpec(row.height,
            function()
                allocatedHeight = allocatedHeight + largestColHeight
            end,
            function(weight)
                heightWeightTotal = heightWeightTotal + weight
            end,
            function(pixels)
                allocatedHeight = allocatedHeight + pixels
            end)

        table.insert(widthWeightTotalList, widthWeightTotal)
        table.insert(allocatedWidthList, allocatedWidth)
    end

    local extraWidthList = {}
    for _, allocedWidth in ipairs(allocatedWidthList) do
        table.insert(extraWidthList, self.width - allocedWidth)
    end
    local extraHeight = self.height - allocatedHeight

    local curY = 0
    for rowIdx, row in ipairs(self.gridRows) do
        local curX = 0
        local height = 0
        local widthWeightTotal = widthWeightTotalList[rowIdx]
        local extraWidth = extraWidthList[rowIdx]

        for _, col in ipairs(row.cols) do
            local width = utils.computeSizeSpec(col.width, col.content:getFullWidth(),
                                                widthWeightTotal, extraWidth)
            height = utils.computeSizeSpec(row.height, row.desiredHeight,
                                           heightWeightTotal, extraHeight)


            utils.switchFitMode(col.hFitMode,
                function()
                    if col.content:getFullWidth() > width then
                        col.content:setWidthIncludesMargin(width)
                    end
                end,
                function()
                    col.content:setWidthIncludesMargin(width)
                end)
            utils.switchFitMode(col.vFitMode,
                function()
                    if col.content:getFullHeight() > height then
                        col.content:setHeightIncludesMargin(height)
                    end
                end,
                function()
                    col.content:setHeightIncludesMargin(height)
                end)
            
            utils.switchHAlign(col.hAlign,
                function()
                    col.content.x = curX
                end,
                function()
                    col.content.x = curX + (width - col.content:getFullWidth()) / 2.0
                end,
                function()
                    col.content.x = curX + width - col.content:getFullWidth()
                end)
            utils.switchHAlign(col.vAlign,
                function()
                    col.content.y = curY
                end,
                function()
                    col.content.y = curY + (height - col.content:getFullHeight()) / 2.0
                end,
                function()
                    col.content.y = curY + height - col.content:getFullHeight()
                end)
            
            curX = curX + width
        end
        curY = curY + height
    end
    
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
        desiredWidth = 0,
        desiredHeight = 0,
        cols = {},
    })

    return self
end

function Grid:rowHeight(spec)
    self:getCurGridRow().height = spec
    return self
end

-- Grid col

function Grid:col(content)
    self.gridColStarted = true
    table.insert(self:getCurGridRow().cols, {
        width = "auto",
        content = nil,
        hAlign = utils.HAlign.Left,
        vAlign = utils.VAlign.Top,
        hFitMode = utils.FitMode.Expand,
        vFitMode = utils.FitMode.Expand,
    })
    self:colContent(content or Pane:new())

    return self
end

function Grid:colWidth(spec)
    self:getCurGridCol().width = spec
    return self
end

function Grid:colContent(content)
    assert(utils.instanceOf(content, Pane))
    self:getCurGridCol().content = content
    content.parent = self
    content:widgetBuild()
    self:widgetBuild()
    return self
end

function Grid:colAlignTopLeft() return self:colHAlignLeft():colVAlignTop() end

function Grid:colAlignBottomRight() return self:colHAlignRight():colVAlignBottom() end

function Grid:colAlignCenter() return self:colHAlignCenter():colVAlignCenter() end

function Grid:colHAlignLeft() return self:colHAlign(utils.HAlign.Left) end

function Grid:colHAlignCenter() return self:colHAlign(utils.HAlign.Center) end

function Grid:colHAlignRight() return self:colHAlign(utils.HAlign.Right) end

function Grid:colVAlignTop() return self:colVAlign(utils.VAlign.Top) end

function Grid:colVAlignCenter() return self:colVAlign(utils.VAlign.Center) end

function Grid:colVAlignBottom() return self:colVAlign(utils.VAlign.Bottom) end

function Grid:colHAlign(align)
    self:getCurGridCol().hAlign = align
    return self
end

function Grid:colVAlign(align)
    self:getCurGridCol().vAlign = align
    return self
end

function Grid:colHFitAuto() return self:colHFitMode(utils.FitMode.Auto) end

function Grid:colHFitExpand() return self:colHFitMode(utils.FitMode.Expand) end

function Grid:colVFitAuto() return self:colVFitMode(utils.FitMode.Auto) end

function Grid:colVFitExpand() return self:colVFitMode(utils.FitMode.Expand) end

function Grid:colFitAuto() return self:colHFitAuto():colVFitAuto() end

function Grid:colFitExpand() return self:colHFitExpand():colVFitExpand() end

function Grid:colHFitMode(mode)
    self:getCurGridCol().hFitMode = mode 
    return self
end

function Grid:colVFitMode(mode)
    self:getCurGridCol().vFitMode = mode
    return self
end

-- Input functions

function Grid:mousepressed(x, y, button, istouch, presses)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:mousepressed(x, y, button, istouch, presses) then return true end
        end
    end
    return false
end

function Grid:mousereleased(x, y, button, istouch, presses)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:mousereleased(x, y, button, istouch, presses) then return true end
        end
    end
    return false
end

function Grid:mousemoved(x, y, dx, dy, istouch)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:mousemoved(x, y, dx, dy, istouch) then return true end
        end
    end
    return false
end

function Grid:wheelmoved(x, y)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:wheelmoved(x, y) then return true end
        end
    end
    return false
end

function Grid:keypressed(key, scancode, isrepeat)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:keypressed(key, scancode, isrepeat) then return true end
        end
    end
    return false
end

function Grid:keyreleased(key, scancode)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:keyreleased(key, scancode) then return true end
        end
    end
    return false
end

function Grid:textinput(text)
    for _, row in ipairs(self.gridRows) do
        for _, col in ipairs(row.cols) do
            if col.content:textinput(text) then return true end
        end
    end
    return false
end

-- Return class
return Grid
