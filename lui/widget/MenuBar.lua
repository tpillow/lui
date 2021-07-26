local utils = require("lui.util.utils")
local style = require("lui.util.style")
local HStackContainer = require("lui.layout.HStackContainer")
local Panel = require("lui.widget.Panel")
local Pane = require("lui.Pane")
local Label = require("lui.widget.Label")

local MenuBar = utils.class(Pane)

-- TODO: redo whole menu system to better allow for customization / submenus
-- TODO: keyboard shortcut integration
-- TODO: alignments

function MenuBar:init()
    self.menus = {}

    self.panel = Panel:new()
    self.hStackContainer = HStackContainer:new()
    self.panel:setContent(self.hStackContainer)

    style.applyStyle(self, "MenuBar")
end

function MenuBar:widgetBuild()
    self.hStackContainer:resetHStackContainer()

    for _, menu in ipairs(self.menus) do
        -- TODO: dropdowns
        -- TODO: stylable
        local tmp = Label:new()
        tmp.text = menu.title
        self.hStackContainer:pushChild(tmp)
    end

    self.panel:widgetBuild()
end

function MenuBar:widgetUpdate(dt)
    self.panel:widgetUpdate(dt)
end

function MenuBar:widgetDraw()
    self.panel:draw()

    self:drawDebugBounds()
end

function MenuBar:widgetSetDesires()
    self.panel:widgetSetDesires()

    self:setSize(self.panel:getFullWidth(), self.panel:getFullHeight())
end

function MenuBar:widgetSetReal()
    self:ensureMinMaxSize()

    self.panel:setSizeIncludesMargin(self.width, self.height)
    self.panel:widgetSetReal()
end

-- Menu building helpers

-- TODO: probably re-do this whole system

function MenuBar:getCurMenu()
    assert(#self.menus > 0)
    return self.menus[#self.menus]
end

function MenuBar:menu(title)
    table.insert(self.menus, {
        title = title,
        items = {},
    })
    self:widgetBuild()
    return self
end

function MenuBar:menuItem(title, handler)
    table.insert(self:getCurMenu().items, {
        title = title,
        handler = handler,
    })
    self:widgetBuild()
    return self
end

return MenuBar
