local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Grid = require("lui.layout.Grid")
local Label = require("lui.widget.Label")
local Container = require("lui.layout.Container")
local MenuBar = require("lui.widget.MenuBar")
local Panel = require("lui.widget.Panel")
local Pane = require("lui.Pane")

local Window = utils.class(Pane)

function Window:init()
    self.title = "Untitled"

    self.panel = Panel:new()
    self.panel.parent = self
    self:addInputListener(self.panel)

    self.titleBarPanel = Panel:new()
    self.titleLabel = Label:new()
    self.titleBarPanel:setContent(self.titleLabel)

    self.menuBar = nil
    self.windowContentContainer = Container:new()
    self.resizeHandle = Label:new() -- TODO: Make this an icon
    self.resizeHandle.text = "█"

    self.showTitleBar = true
    self.alwaysOnBottom = false
    self.alwaysFullScreen = false
    self.canDrag = true
    self.dragging = false
    self.resizable = true
    
    self.mainGrid = Grid:new()
    self.panel:setContent(self.mainGrid)

    self:setMinSize(100, 100)
    self:setWindowContent(nil)
    
    style.applyStyle(self, "Window")
end

function Window:widgetBuild()
    self.mainGrid:resetGrid()

    if self.showTitleBar then
        self.titleLabel.text = self.title
        self.mainGrid:row():
            col(self.titleBarPanel):colWidth("1*")
    end

    if self.menuBar then
        self.mainGrid:row():
            col(self.menuBar):colWidth("1*")
    end

    self.mainGrid:row():rowHeight("1*"):
        col(self.windowContentContainer):colWidth("1*")

    if self.resizable and not self.alwaysFullScreen then
        self.mainGrid:row():
            col():colWidth("1*"):
            col(self.resizeHandle)
    end

    self.panel:widgetBuild()
end

function Window:widgetUpdate(dt)
    self.panel:widgetUpdate(dt)
end

function Window:widgetDraw()
    self.panel:draw()

    self:drawDebugBounds()
end

function Window:widgetSetDesires()
    self.panel:widgetSetDesires()
   
    -- Do not set our desires based on content, since we are a window
    if self.alwaysFullScreen then
        self:setPosition(0, 0)
        self:setSizeIncludesMargin(love.graphics.getWidth(),
                                   love.graphics.getHeight())
    end
end

function Window:widgetSetReal()
    self:ensureMinMaxSize()

    self.panel:setSizeIncludesMargin(self.width, self.height)
    self.panel:widgetSetReal()
end

-- Window content helpers

function Window:setWindowContent(content)
    self.windowContentContainer:setChild(content)
end

function Window:getWindowContent()
    return self.windowContentContainer:getChild()
end

-- Window moving

function Window:mousepressed(x, y, button, istouch, presses)
    if self:globalCoordInBounds(x, y) then
        if self.canDrag and self.titleBarPanel:globalCoordInBounds(x, y) then
            self.dragging = true        
            return true
        elseif self.resizable and not self.alwaysFullScreen and
            self.resizeHandle:globalCoordInBounds(x, y) then
            self.resizing = true
            return true
        end
    end
    return self:paneMousepressed(x, y, button, istouch, presses)
end

function Window:mousemoved(x, y, dx, dy, istouch)
    if self.dragging then
        self:setPosition(self.x + dx, self.y + dy)
        return true
    elseif self.resizing then
        self:setSize(self.width + dx, self.height + dy)
        return true
    end
    return self:paneMousemoved(x, y, dx, dy, istouch)
end

function Window:mousereleased(x, y, button, istouch, presses)
    if self.dragging then
        self.dragging = false
        return true
    elseif self.resizing then
        self.resizing = false
        return true
    end
    return self:paneMousereleased(x, y, button, istouch, presses)
end

return Window
