local utils = require("lui.util.utils")
local Color = require("lui.util.Color")

local style = {}

local cBackground = Color.newFrom("#121212")
local cPanel = Color.newFrom("#5E5E5E")
local cPrimary = Color.newFrom("#E1E1E1")
local cSecondary = Color.newFrom("#BE84FC")

style.defaultStyles = {
    ["Pane"] = {},
        ["Container"] = {},
            ["HStackContainer"] = {},
            ["Window"] = {
                borderColor = cPanel,
                borderWidth = 2,
                titleBarBackgroundColor = cBackground,
                titleBarColor = cPrimary,
                backgroundColor = cBackground,
                titleBarMargin = 5,
                contentMargin = 5,
            },

        ["StackContainer"] = {},
            ["MenuBar"] = {
                crBackground__fillColor = cSecondary,
            },
            ["Panel"] = {
                backgroundColorRect__ = {
                    lineColor = cPanel,
                    lineWidth = 3,
                },
                backgroundColorRect__fillColor = cBackground,
                padding = { 5, 5, 5, 5 },
            },

        ["Grid"] = {},

        ["Label"] = {
            color = cPrimary,
            font = love.graphics.newFont(18),
        },
        ["ColorRect"] = {},
        ["Canvas"] = {},
}

function style.getDefaultStyle(key)
    assert(style.defaultStyles[key], "no default style found for " .. key)
    assert(type(style.defaultStyles[key]) == "table", "style must be a table")
    return style.defaultStyles[key]
end

function style.applyStyle(pane, styleDict)
    local function setProps(obj, dict)
        assert(type(dict) == "table",
               "style.applyStyle: style dict must be a table of properties")
        for key, val in pairs(dict) do
            if utils.strEndsWith(key, "__") then
                local keyPart = key:sub(1, string.len(key) - 2)
                assert(obj[keyPart], "style.applyStyle.setProps: when parsing '" ..
                       key .. "' unfound property: " .. keyPart)
                setProps(obj[keyPart], val)
            else
                local curObj = obj
                local keyParts = utils.strSplit(key, "__")
                for keyPartIdx = 1, #keyParts do
                    local keyPart = keyParts[keyPartIdx]
                    assert(curObj[keyPart], "style.applyStyle.setProps: when parsing '" ..
                           key .. "' unfound property: " .. keyPart)
                    if keyPartIdx < #keyParts then
                        curObj = curObj[keyPart]
                    else
                        curObj[keyPart] = val
                    end
                end
            end
        end
    end

    if type(styleDict) == "table" then
        setProps(pane, styleDict)
    elseif type(styleDict) == "string" then
        setProps(pane, style.getDefaultStyle(styleDict))
    else
        assert(false, "style.applyStyle: styleDict must be a table or default style name")
    end

    pane:widgetBuild()
end

return style
