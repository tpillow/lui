local lui = require("lui.lui")

function love.load()
    a = lui.Pane:new()
    a:setBounds(50, 50, 600, 500)

    b = lui.ColorRect:new()
    b.fillColor = lui.Color.newFromRGBA(1, 1, 1, 1)
    c = lui.ColorRect:new()
    c.fillColor = lui.Color.newFromRGBA(0, 0, 1, 1)
    d = lui.ColorRect:new()
    d.fillColor = lui.Color.newFromRGBA(0, 1, 1, 1)

    a:
        row():rowHeight(50):
            col():colWidth(50):
                colContent(b):
            col():colWidth("1*"):
                colContent(c):
        row():rowHeight(25):
            col():
                colContent(d)
end

function love.update(dt)
    a:update(dt)
end

function love.draw()
    a:draw()
end
