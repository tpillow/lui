local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Pane = require("lui.Pane")

local HStackContainer = utils.class(Pane)

function HStackContainer:init()
    -- TODO: child alignment stuff?
    self.hAlign = utils.HAlign.Left
    self.vAlign = utils.VAlign.Top

    self.mainGrid = Grid:new()
    self.mainGrid.parent = self
    self:addInputListener(self.mainGrid)
    self:resetHStackContainer()

    style.applyStyle(self, "HStackContainer")
end

function HStackContainer:resetHStackContainer()
    self.children = {}
    self:widgetBuild()
end

function HStackContainer:widgetBuild()
    self.mainGrid:resetGrid()

    utils.switchVAlign(self.vAlign,
        function() end,
        function()
            self.mainGrid:row():rowHeight("1*")
        end,
        function()
            self.mainGrid:row():rowHeight("1*")
        end)
   
    self.mainGrid:row()
    utils.switchHAlign(self.hAlign,
        function() end,
        function()
            self.mainGrid:col():colWidth("1*")
        end,
        function()
            self.mainGrid:col():colWidth("1*")
        end)
    
    for _, child in ipairs(self.children) do
        self.mainGrid:col(child)
    end
    
    utils.switchHAlign(self.hAlign,
        function()
            self.mainGrid:col():colWidth("1*")
        end,
        function()
            self.mainGrid:col():colWidth("1*")
        end,
        function() end)
    
    utils.switchVAlign(self.vAlign,
        function()
            self.mainGrid:row():rowHeight("1*")
        end,
        function()
            self.mainGrid:row():rowHeight("1*")
        end,
        function() end)

    self.mainGrid:widgetBuild()
end

function HStackContainer:widgetUpdate(dt)
    self.mainGrid:widgetUpdate(dt)
end

function HStackContainer:widgetDraw()
    self.mainGrid:draw()

    self:drawDebugBounds()
end

function HStackContainer:widgetSetDesires()
    self.mainGrid:widgetSetDesires()
    -- TODO: Needed?
    self:setSize(self.mainGrid:getFullWidth(), self.mainGrid:getFullHeight())
end

function HStackContainer:widgetSetReal()
    self:ensureMinMaxSize()

    self.mainGrid:widgetSetReal()
end

-- Children functions

function HStackContainer:pushChild(child)
    assert(child)
    table.insert(self.children, child)
    self:widgetBuild()
end

function HStackContainer:popChild()
    assert(#self.children > 0)
    table.remove(self.children, #self.children)
    self:widgetBuild()
end

return HStackContainer
