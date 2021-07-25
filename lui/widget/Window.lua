local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Grid = require("lui.layout.Grid")
local Label = require("lui.widget.Label")
local Panel = require("lui.widget.Panel")
local Container = require("lui.layout.Container")
local MenuBar = require("lui.widget.MenuBar")

local Window = utils.class(Panel)

function Window:init()
    self.title = "Untitled"

    self.titleBarPanel = Panel:new()
    self.titleLabel = Label:new()
    self.titleBarPanel:setContent(self.titleLabel)

    self.windowContentContainer = Container:new()

    -- TODO: resizable
    self.menuBar = nil
    self.showTitleBar = true
    self.alwaysOnBottom = false
    self.alwaysFullScreen = false
    self.canDrag = true
    self.dragging = false
    
    self.grid = Grid:new()
    self:setContent(self.grid)

    self.containerDoSelfSetDesires = false
    style.applyStyle(self, "Window")
end

local superWidgetBuild = Window.widgetBuild
function Window:widgetBuild()
    self.grid:reset()

    if self.showTitleBar then
        self.titleLabel.text = self.title
        self.grid:row():
            col(self.titleBarPanel):colWidth("1*")
    end

    if self.menuBar then
        assert(utils.instanceOf(self.menuBar, MenuBar))
        self.grid:row():
            col(self.menuBar):colWidth("1*")
    end

    self.grid:row():rowHeight("1*"):
        col(self.windowContentContainer):colWidth("1*")

    superWidgetBuild(self)
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

function Window:setWindowContent(content)
    self.windowContentContainer:setChild(content)
end

function Window:getWindowContent()
    return self.windowContentContainer:getChild()
end

-- Window moving

local superMousepressed = Window.mousepressed
function Window:mousepressed(x, y, button, istouch, presses)
    if self:globalCoordInBounds(x, y) then
        if self.canDrag and self.titleBarPanel:globalCoordInBounds(x, y) then
            self.dragging = true        
            return true
        end
    end
    return superMousepressed(self, x, y, button, istouch, presses)
end

local superMousemoved = Window.mousemoved
function Window:mousemoved(x, y, dx, dy, istouch)
    if self.dragging then
        self:setPosition(self.x + dx, self.y + dy)
        return true
    end
    return superMousemoved(self, x, y, dx, dy, istouch)
end

local superMousereleased = Window.mousereleased
function Window:mousereleased(x, y, button, istouch, presses)
    if self.dragging then
        self.dragging = false
        return true
    end
    return superMousereleased(self, x, y, button, istouch, presses)
end

return Window
