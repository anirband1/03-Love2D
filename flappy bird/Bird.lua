Bird = Class{}

local GRAVITY = 20
local ANTI_GRAVITY = -5


-- constructor
function Bird:init()
    self.image1 = love.graphics.newImage('flappy_bird.png')
    self.width = self.image1:getWidth()
    self.height = self.image1:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

-- bird falls down faster incrementally
function Bird:update(dt)

    -- ∆ self.dy ≠ 0
    self.dy = self.dy + GRAVITY * dt

    -- clamping to bottom of screen
    -- ∆ self.y ≠ 0
    -- self.y accelerates
    self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy)

    if love.keyboard.wasPressed('space') then

        sounds['flap']:play()

        -- increasing self.dy makes bird 'jump'
        self.dy = ANTI_GRAVITY
    end
end

function Bird:collides(pipe)
    if self.x + self.width >= pipe.x and self.x < pipe.x + pipe.width then
        if self.y + self.height >= pipe.y and self.y <= pipe.y + pipe.height then
            return true
        end
    end
end

-- draw the bird
function Bird:render()
    if playing == true then
        love.graphics.draw(self.image1, self.x, self.y)
    end
end