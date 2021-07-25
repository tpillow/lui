local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Label = require("lui.widget.Label")
local Pane = require("lui.Pane")
local StackContainer = require("lui.layout.StackContainer")
local ColorRect = require("lui.widget.ColorRect")
local MenuBar = require("lui.widget.MenuBar")
local Color = require("lui.util.Color")

local Window = utils.class(Container)

function Window:init()
    self:setMinSize(50, 50)
    self.containerDoSelfSetDesires = false

    self.scTitleBar = StackContainer:new()
    self.crTitleBar = ColorRect:new()
    self.scTitleBar:pushChild(self.crTitleBar)

    self.lblTitle = Label:new()
    self.title = "Untitled"
    self.scTitleBar:pushChild(self.lblTitle)

    self.scWinContent = StackContainer:new()
    self.crWinContent = ColorRect:new()
    self.scWinContent:pushChild(self.crWinContent)

    self.borderColor = Color.newFrom(0, 0, 0, 1)
    self.titleBarBackgroundColor = Color.newFrom(0.5, 0.5, 0.5, 1)
    self.titleBarColor = Color.newFrom(1, 1, 1, 1)
    self.backgroundColor = Color.newFrom(1, 1, 1, 1)
    self.borderWidth = 1
    self.titleBarMargin = 0
    self.contentMargin = 0

    self.menuBar = nil

    self.canDrag = true
    self.dragging = false
    self.showTitleBar = true
    self.alwaysOnBottom = false
    self.alwaysFullScreen = false

    self:setChild(Grid:new())
    self:setWindowContent(Pane:new())

    style.applyStyle(self, "Window")
end

local superWidgetSetDesires = Window.widgetSetDesires
function Window:widgetSetDesires()
    superWidgetSetDesires(self)

    if self.alwaysFullScreen then
        self:setPosition(0, 0)
        self:setSizeIncludesMargin(love.graphics.getWidth(),
                                   love.graphics.getHeight())
    end
end

function Window:widgetBuild()
    self.child:reset()
    if self.showTitleBar then
        self.lblTitle.text = self.title
        self.lblTitle.color = self.titleBarColor
        self.lblTitle:setMargin(self.titleBarMargin)
        self.crTitleBar.fillColor:set(self.titleBarBackgroundColor)
        self.crTitleBar.lineColor:set(self.borderColor)
        self.crTitleBar.lineWidth = self.borderWidth
        self.child:row():
            col(self.scTitleBar):colWidth("1*")
    end
    if self.menuBar then
        assert(utils.instanceOf(self.menuBar, MenuBar))
        self.child:row():
            col(self.menuBar):colWidth("1*")
    end
    self.crWinContent.fillColor:set(self.backgroundColor)
    self.crWinContent.lineColor:set(self.borderColor)
    self.crWinContent.lineWidth = self.borderWidth
    if self.scWinContent:getChildrenCount() > 1 then
        self.scWinContent:peekChild():setMargin(self.contentMargin)
    end
    self.child:row():rowHeight("1*"):
        col(self.scWinContent):colWidth("1*")
end

function Window:setWindowContent(winContent)
    if self.scWinContent:getChildrenCount() > 1 then self.scWinContent:popChild() end
    if winContent then self.scWinContent:pushChild(winContent) end
end

-- Window moving

function Window:mousepressed(x, y, button, istouch, presses)
    if self:globalCoordInBounds(x, y) then
        if self.canDrag and self.scTitleBar:globalCoordInBounds(x, y) then
            self.dragging = true        
            return true
        end
    end
    return false
end

function Window:mousemoved(x, y, dx, dy, istouch)
    if self.dragging then
        self:setPosition(self.x + dx, self.y + dy)
        return true
    end
    return false
end

function Window:mousereleased(x, y, button, istouch, presses)
    if self.dragging then
        self.dragging = false
        return true
    end
    return false
end

return Window
