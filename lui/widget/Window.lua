local utils = require("lui.util.utils")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Label = require("lui.widget.Label")
local Pane = require("lui.Pane")

local Window = utils.class(Container)

function Window:init()
    self.lblTitle = Label:new()
    self:setTitle("Untitled")

    self.dragging = false

    self:setContent(Grid:new())
    self.content.fillParent = true
    self:setWindowContent(Pane:new())
end

function Window:buildGrid(winContent)
    self.content:reset()
    self.content:row():
        col(self.lblTitle):colWidth("1*"):
    row():rowHeight("1*"):
        col(winContent):colWidth("1*")
end

function Window:setWindowContent(winContent)
    self:buildGrid(winContent)
end

function Window:setTitle(title)
    self.lblTitle.text = title
end

-- Window moving

function Window:mousepressed(x, y, button, istouch, presses)
    if self:globalCoordInBounds(x, y) then
        if self.lblTitle:globalCoordInBounds(x, y) then
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
