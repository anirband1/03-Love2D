CountdownState = Class{__includes = BaseState}

DELTA_COUNTDOWN = 0.75

function CountdownState:init()
    self.timer = 0
    self.count = 3
    sounds['countdown']:play()
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > DELTA_COUNTDOWN then
        self.count = self.count - 1
        self.timer = 0
        if self.count >= 1 then
            sounds['countdown']:play()
        end

        if self.count == 0 then
            sounds['go']:play()
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(self.count, 0, 120, VIRTUAL_WIDTH, 'center')
end
