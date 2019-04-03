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


PADDLE_SPEED=200

Class = require 'class'
require 'Paddle'
require 'Ball'

function love.load()

    love.graphics.setDefaultFilter('nearest','nearest')
    --[[
        set font
    ]]
    
    player1Score = 0
    player2Score = 0

    

    math.randomseed(os.time())
    smallFont = love.graphics.newFont('font.ttf',8)
    scoreFont = love.graphics.newFont('font.ttf',32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen =false,
        resizable = false,
        vsync=true   
    })
end
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


    gamestate ='start'
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return'then
        if gamestate=='start' then
            gamestate='play' 
        
        else
            gamestate='start'
            ball:reset()
        end
    end
end

function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy= -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy= PADDLE_SPEED
    else
        player1.dy=0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy =  -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy =  PADDLE_SPEED
    else
        player2.dy=0
    end
    if gamestate == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40,45,52,255)

    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    

    --display score
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)
    --render first paddle
    player1:render()
    player2:render()

    ball:render()

    push:apply('end')
end