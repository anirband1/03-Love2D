GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('start', {
            highScores = loadHighScores()
        })
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['TitleFont'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score:' .. tostring(self.score), 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, 'center')
end