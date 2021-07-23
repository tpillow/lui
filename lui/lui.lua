local lui = {}

-- Core
lui.Pane = require("lui.Pane")

-- Layouts
lui.Grid = require("lui.layout.Grid")

-- Widgets
lui.ColorRect = require("lui.widget.ColorRect")

-- Utils
lui.utils = require("lui.util.utils")
lui.Color = require("lui.util.Color")

-- Debug (GLOBALS)
luiDebugColor = lui.Color.newFromRGBA(1, 0, 0, 1)
luiMarginDebugColor = lui.Color.newFromRGBA(1, 1, 0, 1)
luiDebugLineWidth = 1
luiDebugBounds = true

-- Return module
return lui
