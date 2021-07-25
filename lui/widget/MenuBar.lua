local utils = require("lui.util.utils")
local StackContainer = require("lui.layout.StackContainer")
local ColorRect = require("lui.widget.ColorRect")
local HStackContainer = require("lui.layout.HStackContainer")
local Label = require("lui.widget.Label")

local MenuBar = utils.class(StackContainer)

-- TODO: keyboard shortcut integration
-- TODO: submenus
-- TODO: alignments

function MenuBar:init()
    self.menus = {}

    local tmp = ColorRect:new()
    tmp.fillColor:set(0.25, 0.25, 0.25, 1)
    self:pushChild(tmp)

    self.hsMenus = HStackContainer:new()
    self:pushChild(self.hsMenus)
end

function MenuBar:buildMenus()
    self.hsMenus:reset()

    for _, menu in ipairs(self.menus) do
        -- TODO: dropdowns
        local tmp = Label:new()
        tmp:setMargin(5)
        tmp.text = menu.title
        self.hsMenus:pushChild(tmp)
    end
end

-- Menu building helpers

function MenuBar:getCurMenu()
    assert(#self.menus > 0)
    return self.menus[#self.menus]
end

function MenuBar:menu(title)
    table.insert(self.menus, {
        title = title,
        items = {},
    })
    self:buildMenus()
    return self
end

function MenuBar:menuItem(title, handler)
    table.insert(self:getCurMenu().items, {
        title = title,
        handler = handler,
    })
    self:buildMenus()
    return self
end

return MenuBar
