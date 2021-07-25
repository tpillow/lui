local utils = require("lui.util.utils")
local style = require("lui.util.style")
local Pane = require("lui.Pane")
local Color = require("lui.util.Color")

local Label = utils.class(Pane)

function Label:init()
    self.text = "Label"
    self.color = Color:new()
    self.backgroundColor = Color.newFrom(1, 1, 1, 0)
    -- TODO: font (for some reason love seems to use same newFont ref w/ diff sizes?)

    style.applyStyle(self, "Label")
end

function Label:widgetSetDesires()
    local font = love.graphics.getFont()
    self:setSize(font:getWidth(self.text), font:getHeight())
end

function Label:widgetDraw()
    love.graphics.setColor(self.backgroundColor:unpackRGBA())
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    
    love.graphics.setColor(self.color:unpackRGBA())
    love.graphics.print(self.text, 0, 0)

    self:drawDebugBounds()
end

return Label
