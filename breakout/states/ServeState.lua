ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    -- pass game state from params
    self.bricks = params.bricks
    self.paddle = params.paddle
    self.health = params.health
    self.score = params.score
    self.level = params.level

    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 9

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('play',{
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level
        })
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    love.graphics.setFont(gFonts['instructions'])
    love.graphics.printf("Press enter to start", 0,VIRTUAL_HEIGHT / 2 + 5, VIRTUAL_WIDTH, 'center')
end