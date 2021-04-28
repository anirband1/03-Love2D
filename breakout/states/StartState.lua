StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['select']:play()
    end

    if highlighted == 1 then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gSounds['enterPlay']:play()
            gStateMachine:change('serve',{
                paddle = Paddle(),
                bricks = LevelMaker.createMap(60),
                health = 3,
                score = 0,
                highScores = self.highScores,
                level = 1
            })
        end
    else
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gSounds['enterPlay']:play()
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['TitleFont'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 20, VIRTUAL_WIDTH + 20, 'center')

    love.graphics.setFont(gFonts['instructions'])

    if highlighted == 1 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end

    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT * 3 / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end

    love.graphics.printf('Highscore', 0, VIRTUAL_HEIGHT * 3 / 4 + 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 0.7, 0.3, 1)
end