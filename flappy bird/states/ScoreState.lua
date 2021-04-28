ScoreState = Class{__includes = BaseState}


function ScoreState:enter(params)
    self.score = params.score
    self.image = love.graphics.newImage('dead_bird.png')
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')

        GAP_HEIGHT = 160
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('The bird has stopped flapping', 0, 80, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Score: ' .. tostring(self.score), 0, 110, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press enter to start again', 0, 180, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(self.image, VIRTUAL_WIDTH / 2 - 10, 40)
end