Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
PIPE_SCROLL = -60

PIPE_HEIGHT = 288
PIPE_WIDTH = 42

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)

end


function Pipe:render()
    -- draw(x, y, rotation, X scale, Y scale)
    love.graphics.draw(PIPE_IMAGE, self.x,
        -- if top pipe, add pipe height to y
        -- ternary
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, -- rotation
        1, -- X scale
        self.orientation == 'top' and -1 or 1 -- Y scale
    )

    -- Y scale mirrors the image on the top side (above the y coordinate)

end