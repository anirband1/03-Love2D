Ball = Class{}

--function Ball:init(width, height)
    -- ball initialize
    --self.x = 0
    --self.y = 0
    --self.radius = width
    --self.radius = height
--end

function Ball:init(radius, segments)
    -- ball initialize
    self.radius = radius
    self.segments = segments
end

-- collision
function Ball:collides(paddle)

    -- second paddle , first paddle
    if self.x - self.radius > paddle.x + paddle.width or paddle.x > self.x + self.radius then
        return false
    end


    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.radius then
        return false
    end

    return true
end

-- after death reset
function Ball:reset(paddle)
    if paddle.x > VIRTUAL_WIDTH / 2 then
        self.x = paddle.x - self.radius
        self.dx = -100
    elseif paddle.x < VIRTUAL_WIDTH / 2 then
        self.x = paddle.x + paddle.width + self.radius
        self.dx = 100
    end
    self.y = paddle.y + (paddle.height / 2) - self.radius
    self.dy = math.random(-50, 50)
    --print("paddle = ", paddle.x, ", ", paddle.y)
    --print("ball   = ", self.x, ", ", self.y)
    gameState = 'start'
end

-- ball movement
function Ball:update(dt)
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end

-- draw the ball
function Ball:render()
    --love.graphics.rectangle('fill', self.x, self.y, self.radius, self.radius)
    love.graphics.circle('fill', self.x, self.y, self.radius, self.segments)
end


