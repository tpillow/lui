local lui = require("lui.lui")

function love.load()
    a = lui.Grid:new()
    a:setBounds(50, 50, 600, 500)
    a:setMargin(10)

    b = lui.ColorRect:new()
    b.fillColor = lui.Color.newFromRGBA(1, 1, 1, 1)
    b:setMargin(5)
    c = lui.ColorRect:new()
    c.fillColor = lui.Color.newFromRGBA(0, 0, 1, 1)
    d = lui.ColorRect:new()
    d.fillColor = lui.Color.newFromRGBA(0, 1, 1, 1)

    a:
        row():rowHeight(50):
            col(b):colWidth(50):
            col(c):colWidth("1*"):
        row():rowHeight(25):
            col(d)
end

function love.update(dt)
    a:update(dt)
end

function love.draw()
    a:draw()
end
