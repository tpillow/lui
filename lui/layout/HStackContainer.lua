local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Pane = require("lui.Pane")

local HStackContainer = utils.class(Container)

function HStackContainer:init()
    -- TODO: child alignment stuff?
    self.hAlign = utils.HAlign.Left
    self.vAlign = utils.VAlign.Top

    self.children = {}
    self:setChild(Grid:new())

    style.applyStyle(self, "HStackContainer")
end

function HStackContainer:resetHStackContainer()
    self.children = {}
    self:widgetBuild()
end

function HStackContainer:widgetDraw()
    for _, child in ipairs(self.children) do
        child:draw()
    end

    self:drawDebugBounds()
end

local superWidgetBuild = HStackContainer.widgetBuild
function HStackContainer:widgetBuild()
    self.child:resetGrid()

    utils.switchVAlign(self.vAlign,
        function() end,
        function()
            self.child:row():rowHeight("1*")
        end,
        function()
            self.child:row():rowHeight("1*")
        end)
   
    self.child:row()
    utils.switchHAlign(self.hAlign,
        function() end,
        function()
            self.child:col():colWidth("1*")
        end,
        function()
            self.child:col():colWidth("1*")
        end)
    
    for _, child in ipairs(self.children) do
        child:widgetBuild()
        self.child:col(child)
    end
    
    utils.switchHAlign(self.hAlign,
        function()
            self.child:col():colWidth("1*")
        end,
        function()
            self.child:col():colWidth("1*")
        end,
        function() end)
    
    utils.switchVAlign(self.vAlign,
        function()
            self.child:row():rowHeight("1*")
        end,
        function()
            self.child:row():rowHeight("1*")
        end,
        function() end)

    superWidgetBuild(self)
end

function HStackContainer:pushChild(child)
    assert(utils.instanceOf(child, Pane))
    table.insert(self.children, child)
    self:widgetBuild()
end

function HStackContainer:popChild()
    assert(#self.children > 0)
    table.remove(self.children, #self.children)
    self:widgetBuild()
end

return HStackContainer
