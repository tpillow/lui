local lui = require("lui.lui")

function love.load()
    love.graphics.setFont(love.graphics.newFont(24))

    a = lui.Grid:new()
    a:setBounds(50, 50, 600, 500)
    a:setMargin(10)
    a.fillParent = true

    b = lui.ColorRect:new()
    b.fillColor = lui.Color.newFromRGBA(1, 1, 1, 1)
    b:setMargin(5)
    c = lui.ColorRect:new()
    c:setMargin(20)
    c.fillColor = lui.Color.newFromRGBA(0, 0, 1, 1)
    c2 = lui.ColorRect:new()
    c2.fillColor = lui.Color.newFromRGBA(0, 0, 1, 1)
    d = lui.ColorRect:new()
    d.fillColor = lui.Color.newFromRGBA(0, 1, 1, 1)
    d2 = lui.Label:new()
    e = lui.ColorRect:new()
    e:setMargin(10, 20)
    e.fillColor = lui.Color.newFromRGBA(1, 1, 0, 1)
    f = lui.ColorRect:new()
    f.fillColor = lui.Color.newFromRGBA(1, 0.5, 0.5, 1)

    a:
        row():
            col(b):colWidth(50):
            col(c):colWidth("1*"):
            col(c2):colWidth("3*"):
        row():rowHeight("auto"):
            col(d):col(d2):
        row():rowHeight("1*"):
            col(e):
        row():rowHeight("4*"):
            col(f)
end

function love.update(dt)
    a:update(dt)
end

function love.draw()
    a:draw()
end
