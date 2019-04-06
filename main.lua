--[[
Pong Game
]]

--[[
    Set window width and height
]]

collided='No'
push = require 'push'
WINDOW_WIDTH =1280 
WINDOW_HEIGHT=720


VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243


PADDLE_SPEED=200
servingPlayer=1
effectTimer=0
Class = require 'class'
require 'Paddle'
require 'Ball'
ballColor={255,255,255}
sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
}
function love.load()

    love.graphics.setDefaultFilter('nearest','nearest')
    --[[
        set font
    ]]
    
    player1Score = 0
    player2Score = 0

    
    love.window.setTitle('Pong')
    math.randomseed(os.time())
    smallFont = love.graphics.newFont('font.ttf',8)
    scoreFont = love.graphics.newFont('font.ttf',32)
    love.graphics.setFont(smallFont)
    ballColor={math.random(50,255),math.random(50,255),math.random(50,255)}
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen =false,
        resizable = false,
        vsync=true   
    })
end
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer= math.random(1,2)
    gamestate ='start'
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return'then
        if gamestate=='start' then
            gamestate='play' 
        
        elseif gamestate =='done' then
            gamestate='start'
            player1Score=0
            player2Score=0
            
            ball:reset()
        end
    end
end

function love.update(dt)
    -- player 1 movement
        
    if ball:collides(player1) then
        collided ='player1'
        sounds['paddle_hit']:play()
        ball.dx = -ball.dx * 1.03
        ball.x = player1.x + 5
        effectTimer=love.timer.getFPS()/5
        -- keep velocity going in the same direction, but randomize it
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    if ball:collides(player2) then
        collided = 'player2'
        sounds['paddle_hit']:play()
        ball.dx = -ball.dx * 1.03
        ball.x = player2.x - 4
        effectTimer=love.timer.getFPS()/5
        -- keep velocity going in the same direction, but randomize it
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    if ball.y <=0 then
        ball.y=0
        ball.dy=-ball.dy
        sounds['wall_hit']:play()

    end
    if ball.y>=VIRTUAL_HEIGHT-4 then
        ball.y=VIRTUAL_HEIGHT-4
        ball.dy=-ball.dy
        sounds['wall_hit']:play()
    end

    if ball.x <=0 then
        player2Score=player2Score+1
        sounds['score']:play()
        servingPlayer = 2
        ball:reset()
        gamestate='start'
        
        if player2Score==10 then
            gamestate='done'
            winningPlayer = 'Player2'
        end
    elseif ball.x+4 >= VIRTUAL_WIDTH  then
        player1Score=player1Score+1
        servingPlayer=1
        sounds['score']:play()
        ball:reset()
        
        gamestate='start'
        if player1Score==10 then
            gamestate='done'
            winningPlayer='Player1'
        end
    end


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
    if gamestate == 'done' then
        love.graphics.print(winningPlayer ..' wins!', VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/5)
    end
    
    --display score
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2+30, VIRTUAL_HEIGHT/3)
    --render first paddle
    if collided == 'player1' then
        love.graphics.setColor(ballColor)
    end
    player1:render()
    love.graphics.setColor(255,255,255)
    if collided == 'player2' then
        love.graphics.setColor(ballColor)
    end
    player2:render()
    
    
    love.graphics.setColor(255,255,255)
    ball:render()
    
    if effectTimer==1 then
        ballColor={math.random(50,255),math.random(50,255),math.random(50,255)}
    end
    if effectTimer>0 then
        effectTimer= effectTimer-1
    else
        collided ='No'
        
    end
    push:apply('end')
end