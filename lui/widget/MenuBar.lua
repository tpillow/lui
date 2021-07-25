local utils = require("lui.util.utils")
local style = require("lui.util.style")
local HStackContainer = require("lui.layout.HStackContainer")
local Panel = require("lui.widget.Panel")
local Label = require("lui.widget.Label")

local MenuBar = utils.class(Panel)

-- TODO: redo whole menu system to better allow for customization / submenus
-- TODO: keyboard shortcut integration
-- TODO: alignments

function MenuBar:init()
    self.menus = {}

    self.hStackContainer = HStackContainer:new()
    self:setContent(self.hStackContainer)

    style.applyStyle(self, "MenuBar")
end

local superWidgetBuild = MenuBar.widgetBuild
function MenuBar:widgetBuild()
    self.hStackContainer:resetHStackContainer()

    for _, menu in ipairs(self.menus) do
        -- TODO: dropdowns
        -- TODO: stylable
        local tmp = Label:new()
        tmp.text = menu.title
        self.hStackContainer:pushChild(tmp)
    end

    superWidgetBuild(self)
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
