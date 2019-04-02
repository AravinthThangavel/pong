--[[
Pong Game
]]

--[[
    Set window width and height
]]
push = require 'push'
WINDOW_WIDTH =1280 
WINDOW_HEIGHT=720


VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243

function love.load()

    love.graphics.setDefaultFilter('nearest','nearest')
    --[[
        set font
    ]]
    smallFont = love.graphics.newFont('font.ttf',8)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen =false,
        resizable = false,
        vsync=true   
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40,45,52,255)

    love.graphics.printf('Hello Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    
    --render first paddle
    love.graphics.rectangle('fill',10,30,5,20)

    --render second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-50,5,20)

    --ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,2,2)

    push:apply('end')
end