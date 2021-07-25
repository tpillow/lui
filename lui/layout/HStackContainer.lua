local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Pane = require("lui.Pane")

local HStackContainer = utils.class(Container)

function HStackContainer:init()
    -- TODO: need to re-build when these change
    -- TODO: content alignment stuff?
    self.hAlign = utils.HAlign.Left
    self.vAlign = utils.VAlign.Top

    self.children = {}
    self:setContent(Grid:new())

    style.applyStyle(self, "HStackContainer")
end

function HStackContainer:reset()
    self.children = {}
    self:widgetBuild()
end

function HStackContainer:widgetBuild()
    self.content:reset()

    utils.switchVAlign(self.vAlign,
        function() end,
        function()
            self.content:row():rowHeight("1*")
        end,
        function()
            self.content:row():rowHeight("1*")
        end)
   
    self.content:row()
    utils.switchHAlign(self.hAlign,
        function() end,
        function()
            self.content:col():colWidth("1*")
        end,
        function()
            self.content:col():colWidth("1*")
        end)
    
    for _, child in ipairs(self.children) do
        child:widgetBuild()
        self.content:col(child)
    end
    
    utils.switchHAlign(self.hAlign,
        function()
            self.content:col():colWidth("1*")
        end,
        function()
            self.content:col():colWidth("1*")
        end,
        function() end)
    
    utils.switchVAlign(self.vAlign,
        function()
            self.content:row():rowHeight("1*")
        end,
        function()
            self.content:row():rowHeight("1*")
        end,
        function() end)
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