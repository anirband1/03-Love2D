-- MODULES
-- push is a library for resolution

push = require 'push'

-- class
Class = require 'class'

require 'Paddle'

require 'Ball'

-- INITIALIZE

-- actual window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual dimensions for retro aspect of game(text)
VIRTUAL_WIDTH =  432 -- 432
VIRTUAL_HEIGHT =  243 -- 243

-- speed of paddle, multiplied by dt in update
PADDLE_SPEED = 200




-- runs it once, initializes everything used in the game
function love.load()

    -- nearest-neighbour filtering
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- RANDOM

    math.randomseed(os.time())

    -- initializing retro font for text
    medFont = love.graphics.newFont('courier.ttf',12)

    -- initializing score newFont
    scoreFont = love.graphics.newFont('pixel.ttf', 45)

    -- WINDOW

    love.window.setTitle('Ping Pong')

    -- low res window for text within high res window for game (for retro feel)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- SOUNDS

    sounds = {
        ['paddle_hit'] = love.audio.newSource("sounds/Bounce.wav", "static"),
        ['Score'] = love.audio.newSource("sounds/Score.wav", "static")
    }

    -- INITIALIZED

    -- score
    Player1Score = 0
    Player2Score = 0

    -- paddle positions on the Y axis
    Player1 = Paddle(10, 30, 5, 35)
    Player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 35)

    -- game state
    gameState = 'start'

    -- serving player is chosen randomly
    servingPlayer = math.random(2) == 1 and Player1 or Player2

    -- ball
    --ball = Ball(4,4)
    ball = Ball(2,30)
    ball:reset(servingPlayer)

    -- score to window
    winningScore = 10

end





function love.resize(w, h)
    push:resize(w, h)
end



function love.update(dt)

    -- PLAYER 1 PADDLE

    -- paddle up
    if love.keyboard.isDown('w') then
        Player1.dy = -PADDLE_SPEED
        -- paddle down
    elseif love.keyboard.isDown('s') then
        Player1.dy = PADDLE_SPEED
    else
        Player1.dy = 0
    end

    -- PLAYER 2 PADDLE

    -- paddle up
    if love.keyboard.isDown('up') then
        Player2.dy = -PADDLE_SPEED
        -- paddle down
    elseif love.keyboard.isDown('down') then
        Player2.dy = PADDLE_SPEED
    else
        Player2.dy = 0
    end

    Player1:update(dt)
    Player2:update(dt)

    -- BALL

    if gameState == 'play' then

        -- ball changes direction when it collides
        if ball:collides(Player1) then
            
            -- increases speed by 1% each time it collides
            ball.dx = -ball.dx * 1.1

            -- preventing ∞ loop of ball in paddle (paddle width)
            ball.x = Player1.x + ball.radius + Player1.width

            -- for randomizing direction after collision by a bit
            if ball.dy < 0 then
                ball.dy = -math.random(30, 120)
            else
                ball.dy = math.random(30, 120)
            end

            sounds['paddle_hit']:play()
        end

        if ball:collides(Player2) then

            -- increases speed by 1% each time it collides
            ball.dx = -ball.dx * 1.1

            -- preventing ∞ loop of ball in paddle (ball radius)
            ball.x = Player2.x - ball.radius

            -- for randomizing direction after collision by a bit
            if ball.dy < 0 then
                ball.dy = -math.random(30, 120)
            else
                ball.dy = math.random(30, 120)
            end
            sounds['paddle_hit']:play()
        end

        if ball.y <= ball.radius then
            ball.dy = -ball.dy
            ball.y = ball.y + 2
            sounds['paddle_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - ball.radius then
            ball.dy = -ball.dy
            ball.y = ball.y - 2
            sounds['paddle_hit']:play()
        end

        ball:update(dt)

        if ball.x < 0  then
            Player2Score = Player2Score + 1
            if Player2Score == winningScore then
                loser = Player1
                winner= "Player 2 "
            end
            sounds['Score']:play()
            ball:reset(Player2)
        end

        if ball.x > VIRTUAL_WIDTH  then
            Player1Score = Player1Score + 1
            if Player1Score == winningScore then
                loser = Player2
                winner= "Player 1 "
            end
            sounds['Score']:play()
            ball:reset(Player1)
        end

    elseif gameState == 'done' then
        Player1Score = 0
        Player2Score = 0
        ball:reset(loser)
    end
end




-- EVENT CHECKS
-- press esc key to exit love
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    -- game
    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset(servingPlayer)
        end
    end
end




-- all graphics and text for the game
function love.draw()
    -- applies properties of above mentioned push
    push:apply('start')

    -- BACKGROUND
    -- set background color
    love.graphics.clear(0.2, 0.2, 0.2, 255)       -- R, G, B, opacity

    -- TEXT
    
    -- set active font to score font
    love.graphics.setFont(scoreFont)
    
    -- player 1 score
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH/2 - 104, 24)
    
    -- player 2 score
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH/2 + 80, 24)
    
    -- set love's active font to above
    love.graphics.setFont(medFont)

    -- print Ping Pong
    -- printf is used for aligning (text, X, Y, align boundary, align mode)
    love.graphics.printf("Ping Pong",0,10,VIRTUAL_WIDTH,'center')

    -- game over
    if Player1Score == winningScore or Player2Score == winningScore then
        love.graphics.printf(winner .. "wins",0,20,VIRTUAL_WIDTH,'center')
        gameState = 'done'
    end
    -- PADDLES

    -- paddle (left side)
    Player1:render()

    -- paddle (right side)
    Player2:render()

    -- BALL
    ball:render()

    push:apply('end')

    -- FPS
    DisplayFPS()
end




function DisplayFPS()
    smallFont = love.graphics.newFont('courier.ttf', 24)
    love.graphics.setFont(smallFont)
    love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 10, 10)
end