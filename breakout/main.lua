require 'dependencies/Classes'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Breakout of here')

    math.randomseed(os.time())

    gFonts = {
        ['TitleFont'] = love.graphics.newFont('dependencies/fonts/TitleFont.ttf', 58),
        ['large'] = love.graphics.newFont('dependencies/fonts/TitleFont.ttf', 40),
        ['instructions'] = love.graphics.newFont('dependencies/fonts/instructions.ttf', 16),
        ['medium'] = love.graphics.newFont('dependencies/fonts/medium.ttf', 24)
    }

    gTextures = {
        ['background'] = love.graphics.newImage('pictures/background.png'),
        ['main'] = love.graphics.newImage('pictures/mainsheet.png'),
        ['particles'] = love.graphics.newImage('pictures/particle.png')
    }

    gFrames = {
        ['paddle'] = GeneratePaddleQuads(gTextures['main']),
        ['balls'] = GenerateBallQuads(gTextures['main']),
        ['bricks'] = GenerateBrickQuads(gTextures['main']),
        ['hearts'] = GenerateHeartsQuads(gTextures['main'])
    }

    gSounds = {
        ['select'] = love.audio.newSource('dependencies/sounds/select.wav', 'static'),
        ['enterPlay'] = love.audio.newSource('dependencies/sounds/enterPlay.wav', 'static'),
        ['collides'] = love.audio.newSource('dependencies/sounds/collides.wav', 'static'),
        ['pause'] = love.audio.newSource('dependencies/sounds/pause.wav', 'static'),
        ['hurt'] = love.audio.newSource('dependencies/sounds/hurt.wav', 'static'),
        ['game-over'] = love.audio.newSource('dependencies/sounds/game-over.wav', 'static'),
        ['victory'] = love.audio.newSource('dependencies/sounds/victory.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['enter-high-scores'] = function() return EnterHighScoreState() end
    }

    math.randomseed(os.time())

    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if keysPressed[key] then
        return true
    else
        return false
    end 
end

function love.update(dt)
    gStateMachine:update(dt)

    keysPressed = {}
end


function love.draw()
    push:apply('start')

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
    
        -- coordinates
        0, 0,

        -- no rotation (radians)
        0,

        -- scale on X and Y
        VIRTUAL_WIDTH / (backgroundWidth), VIRTUAL_HEIGHT / (backgroundHeight)
    )

    gStateMachine:render()

    push:apply('end')

    DisplayFPS()

end

function DisplayFPS()
    love.graphics.setFont(gFonts['instructions'])
    love.graphics.print('FPS ' .. tostring(love.timer.getFPS()), 5, 5)
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100
    
    for i=1, health do
        love.graphics.draw(gTextures['main'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    for i=1, 3 - health do
        love.graphics.draw(gTextures['main'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['instructions'])
    love.graphics.print('Score ' .. tostring(score), VIRTUAL_WIDTH - 60, 5)
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('breakout.lst') then
        local score = ''
        for i = 10, 1, -1 do
            score = score .. 'AD\n'
            score = score .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', score)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

