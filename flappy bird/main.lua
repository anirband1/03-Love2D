-- MODULES

push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'

require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 20
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

noOfPipes = 0

playing = true


function love.load()

    -- avoid making the images  blurry
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- title
    love.window.setTitle('Flapping Bird')

    smallFont = love.graphics.newFont('flappyFont.ttf', 8)
    mediumFont = love.graphics.newFont('scoreFont.ttf', 14)
    flappyFont = love.graphics.newFont('flappyFont.ttf', 28)
    hugeFont = love.graphics.newFont('scoreFont.ttf', 76)

    -- window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizeable = true,
        vsync = true
    })

    -- sounds
    sounds = {
        ['flap'] = love.audio.newSource('sounds/flap.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
        ['countdown'] = love.audio.newSource('sounds/countdown.wav', 'static'),
        ['go'] = love.audio.newSource('sounds/go.wav', 'static')
    }

    -- INPUT KEY TABLE

    -- custom keyboard input function (table)
    keysPressed = {}


    -- INITIALIZED

    math.randomseed(os.time())

    gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    })
    gStateMachine:change('title')
end

function love.resize(w, h)
    push:resize(w, h)
end




function love.keypressed(key)

    -- setting any and every key pressed as true
    keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end


-- custom function
-- this key is different from above key
function love.keyboard.wasPressed(key)

    -- we can now call this function globally
    -- only if both the above keys match (and)
    if keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)

    if playing then
        -- BACKGROUND

        -- mountains scrolling
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT

        -- ground scrolling
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH

        -- state machine

        gStateMachine:update(dt)

    end
    -- INPUT TABLE

    -- resetting keyboard table to prevent continuous update
    keysPressed = {}
end




function love.draw()

    push:apply('start')

    -- render order matters

    -- background draw
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    -- ground render
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:apply('end')
end