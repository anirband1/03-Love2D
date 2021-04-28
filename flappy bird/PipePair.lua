PipePair = Class{}

GAP_HEIGHT = 160

function PipePair:init(y)

    self.x = VIRTUAL_WIDTH

    -- defined in main
    self.y = y

    -- table of all pairs of pipes
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- if removed while iterating, glitches and bugs
    self.remove = false

    -- score tracking
    self.scored = false
end

function PipePair:update(dt)

    -- if pipe hasn't gone out of the screen yet
    if self.x > -PIPE_WIDTH then

        -- scroll both the pipes
        self.x = self.x + PIPE_SCROLL * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x

    else
        self.remove = true
    end

end

function PipePair:render()

    -- for every key-value pair in the table self.pipes
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
