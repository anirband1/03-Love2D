VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.ball = params.ball
    self.health = params.health
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    self.ball.x = self.paddle.x + self.paddle.width / 2
    self.ball.y = self.paddle.y - 9

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            paddle = self.paddle,
            ball = self.ball,
            score = self.score,
            health = self.health
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Congratulations! level' .. tostring(self.level) .. 'is complete.', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['instructions'])
    love.graphics.printf('Press enter to continue', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
end