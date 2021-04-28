PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200) 
    self.ball.dy = math.random(-50, -60) 
end


function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
        
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end
    
    if self.ball:collides(self.paddle) then
        self.ball.dy = -self.ball.dy
        self.ball.y = self.paddle.y - self.ball.height - 1
        gSounds['collides']:play()
        
        -- changing ball direction at paddle
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = math.min(-180, -20 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x)))
            
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = math.min(180, 20 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x)))
        end
        
    end
    
    self.paddle:update(dt)
    self.ball:update(dt)
    
    
    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            self.score = self.score + (brick.tier * 10 + brick.color * 5)
            brick:hit()

            if self:checkVictory() then
                gSounds['victory']:play()
                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball
                })
            end
            
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
                
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
                
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
                
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end
            break
        end
    end
    
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()
        
        if self.health == 0 then
            gSounds['game-over']:play()
            gStateMachine:change('game-over', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                level = self.level
            })
        end
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end

function PlayState:render()
    self.paddle:render()
    self.ball:render()
    
    if self.paused then
        love.graphics.setFont(gFonts['TitleFont'])
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT / 2 - 29, VIRTUAL_WIDTH, 'center')
    end
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderHealth(self.health)
    renderScore(self.score)
end