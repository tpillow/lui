local lui = require("lui.lui")

function love.load()
    love.graphics.setFont(love.graphics.newFont(16))
    love.window.setMode(800, 600, { resizable = true })

    stage = lui.Stage:new()

    a = lui.Grid:new()

    b = lui.ColorRect:new()
    b.fillColor = lui.Color.newFrom(1, 1, 1, 1)
    b:setMargin(5)
    c = lui.ColorRect:new()
    c:setMargin(20)
    c.fillColor = lui.Color.newFrom(0, 0, 1, 1)
    c2 = lui.ColorRect:new()
    c2.fillColor = lui.Color.newFrom(0, 0, 1, 1)
    d = lui.ColorRect:new()
    d.fillColor = lui.Color.newFrom(0, 1, 1, 1)
    d2 = lui.Label:new()
    e = lui.ColorRect:new()
    e:setMargin(10, 20)
    e2 = lui.Label:new()
    e2.text = "Interesting text..."
    e.fillColor = lui.Color.newFrom(1, 1, 0, 1)
    f = lui.ColorRect:new()
    f.fillColor = lui.Color.newFrom(1, 0.5, 0.5, 1)

    a:
        row():
            col(b):colWidth(50):
            col(c):colWidth("1*"):
            col(c2):colWidth("3*"):
        row():rowHeight("auto"):
            col(d):col(d2):
        row():rowHeight("1*"):
            col(e):colWidth(100):
            col(e2):colWidth("1*"):colFitAuto():colAlignBottomRight():
        row():rowHeight("4*"):
            col(f):colWidth("1*")

    win0 = lui.Window:new()
    win0.showTitleBar = false
    win0.alwaysFullScreen = true
    win0.alwaysOnBottom = true
    win0:setWindowContent(a)

    stage:addChild(win0)

    win1 = lui.Window:new()
    win1.title = "Window #1"
    win1:setBounds(200, 200, 300, 300)

    stage:addChild(win1)

    --mb1 = lui.MenuBar:new()
    --mb1:menu("File"):
    --        menuItem("Load"):
    --        menuItem("Save"):
    --        menuItem("Exit"):
    --    menu("Edit"):
    --        menuItem("Copy"):
    --        menuItem("Paste")
    --win1.menuBar = mb1
    
    --w0 = lui.ColorRect:new()
    --w0.fillColor = lui.Color.newFrom(0.2, 0.2, 0.2, 0.5)
    --win1:setWindowContent(w0)
    --w1 = lui.Label:new()
    --w1.text = "Some content!"
    --win1:setWindowContent(w1)

    --stage:addChild(win1)
end

function love.update(dt)
    stage:update(dt)
end

function love.draw()
    stage:draw()
end

-- Input functions

function love.mousepressed(x, y, button, istouch, presses)
    stage:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    stage:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    stage:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
    stage:wheelmoved(x, y)
end

function love.keypressed(key, scancode, isrepeat)
    stage:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    stage:keyreleased(key, scancode)
end

function love.textinput(text)
    stage:textinput(text)
end
