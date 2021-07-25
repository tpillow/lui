local utils = require("lui.util.utils")
local Container = require("lui.layout.Container")
local Grid = require("lui.layout.Grid")
local Label = require("lui.widget.Label")
local Pane = require("lui.Pane")
local StackContainer = require("lui.layout.StackContainer")
local ColorRect = require("lui.widget.ColorRect")

local Window = utils.class(Container)

function Window:init()
    self.scTitlebar = StackContainer:new()
    local tmp = ColorRect:new()
    tmp.fillColor:set(0, 0, 0, 0.95)
    self.scTitlebar:pushChild(tmp)

    self.lblTitle = Label:new()
    self:setTitle("Untitled")
    self.scTitlebar:pushChild(self.lblTitle)

    self.scWinContent = StackContainer:new()
    tmp = ColorRect:new()
    tmp.fillColor:set(0, 0, 0, 0.2)
    self.scWinContent:pushChild(tmp)

    self.dragging = false

    self:setContent(Grid:new())
    self.content.fillParent = true
    self:setWindowContent(Pane:new())
    self:buildGrid()
end

function Window:buildGrid()
    self.content:reset()
    self.content:row():
        col(self.scTitlebar):colWidth("1*"):
    row():rowHeight("1*"):
        col(self.scWinContent):colWidth("1*")
end

function Window:setWindowContent(winContent)
    if self.scWinContent:getChildrenCount() > 1 then self.scWinContent:popChild() end
    if winContent then self.scWinContent:pushChild(winContent) end
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
