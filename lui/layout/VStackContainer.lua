local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Pane = require("lui.Pane")

local VStackContainer = utils.class(Pane)

function VStackContainer:init()
    -- TODO: child alignment stuff?
    self.hAlign = utils.HAlign.Left
    self.vAlign = utils.VAlign.Top

    self.mainGrid = Grid:new()
    self.mainGrid.parent = self
    self:addInputListener(self.mainGrid)
    self:resetVStackContainer()

    style.applyStyle(self, "VStackContainer")
end

function VStackContainer:resetVStackContainer()
    self.children = {}
    self:widgetBuild()
end

function VStackContainer:widgetBuild()
    self.mainGrid:resetGrid()

    utils.switchVAlign(self.vAlign,
        function() end,
        function()
            self.mainGrid:row():rowHeight("1*")
        end,
        function()
            self.mainGrid:row():rowHeight("1*")
        end)
    
    for _, child in ipairs(self.children) do
        self.mainGrid:row()
        utils.switchHAlign(self.hAlign,
            function() end,
            function()
                self.mainGrid:col():colWidth("1*")
            end,
            function()
                self.mainGrid:col():colWidth("1*")
            end)

        self.mainGrid:col(child)
    
        utils.switchHAlign(self.hAlign,
            function()
                self.mainGrid:col():colWidth("1*")
            end,
            function()
                self.mainGrid:col():colWidth("1*")
            end,
            function() end)
    end
    
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

function VStackContainer:widgetUpdate(dt)
    self.mainGrid:widgetUpdate(dt)
end

function VStackContainer:widgetDraw()
    self.mainGrid:draw()

    self:drawDebugBounds()
end

function VStackContainer:widgetSetDesires()
    self.mainGrid:widgetSetDesires()
    
    self:setSize(self.mainGrid:getFullWidth(), self.mainGrid:getFullHeight())
end

function VStackContainer:widgetSetReal()
    self:ensureMinMaxSize()

    self.mainGrid:widgetSetReal()
end

-- Children functions

function VStackContainer:pushChild(child)
    assert(child)
    table.insert(self.children, child)
    self:widgetBuild()
end

function VStackContainer:popChild()
    assert(#self.children > 0)
    table.remove(self.children, #self.children)
    self:widgetBuild()
end

return VStackContainer
