local lui = {}

-- Core
lui.Pane = require("lui.Pane")
lui.Stage = require("lui.Stage")

-- Layouts
lui.Grid = require("lui.layout.Grid")
lui.Container = require("lui.layout.Container")
lui.StackContainer = require("lui.layout.StackContainer")

-- Widgets
lui.Window = require("lui.widget.Window")
lui.Label = require("lui.widget.Label")
lui.ColorRect = require("lui.widget.ColorRect")
lui.Canvas = require("lui.widget.Canvas")

-- Utils
lui.utils = require("lui.util.utils")
lui.Color = require("lui.util.Color")

-- Debug (GLOBALS)
luiDebugColor = lui.Color.newFromRGBA(1, 0, 0, 1)
luiDebugMarginColor = lui.Color.newFromRGBA(1, 1, 0, 1)
luiDebugLineWidth = 1
luiDebugBounds = true

-- Return module
return lui
