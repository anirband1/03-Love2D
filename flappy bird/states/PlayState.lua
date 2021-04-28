PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()

    -- to loop through similar objects, iterate through table containing all of them
    self.pipePairs = {}

    self.spawnTimer = 0

    -- arbitrary
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    -- score tracking
    self.score = 0

    -- sounds

end


function PlayState:update(dt)
    -- PIPES

    -- incrementing the timer by each frame as seconds
    self.spawnTimer = self.spawnTimer + dt


    -- for once every 2 seconds
    if self.spawnTimer > 2 then

        -- y is for topmost pipe. controls the pair
        -- ranging from 10 below the top of the negative screen and
        -- 90 above the bottom of negative screen
        -- bcos 90 is gap between pipes
        -- .max and .min clamping pipes inside sceen
        -- -40 and 40 to give it difference between pairs
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-GAP_HEIGHT, GAP_HEIGHT), VIRTUAL_HEIGHT - GAP_HEIGHT - 20 - PIPE_HEIGHT))

        -- to give a contour across the gaps
        -- more random
        -- self.lastY = y

        -- takes the table first and then the value to be added
        table.insert(self.pipePairs, PipePair(y))

        noOfPipes = noOfPipes + 1
        if noOfPipes % 10 == 0 then
            GAP_HEIGHT = GAP_HEIGHT - 20
        end

        -- reset timer or else pipe gets called every frame thereafter
        self.spawnTimer = 0
    end

    -- for key, value in pairs(table)
    -- iterating over a dictionary to get access to the key value pairs
    -- pipe attributes in 'pair'
    -- k defined implicitly
    for k, pair in pairs(self.pipePairs) do
        
        pair:update(dt)

        if not pair.scored then
            if self.bird.x >= pair.x + PIPE_WIDTH then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        -- collision update
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score',{
                    score = self.score
                })
                sounds['death']:play()
            end
            if self.bird.y + self.bird.width >= VIRTUAL_HEIGHT - 16 then
                gStateMachine:change('score',{
                    score = self.score
                })
                sounds['death']:play()
            end
        end
    end

    -- to remove the element
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- self.bird

    -- self.bird's gravity
    self.bird:update(dt)
end

function PlayState:render()

    -- render order matters

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- score
    love.graphics.setFont(flappyFont)
    love.graphics.print("Score: " .. tostring(self.score), 8, 8)


    -- The bird
    self.bird:render()

end