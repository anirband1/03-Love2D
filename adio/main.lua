require 'Classes'

-- window
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- character
CHARACTER_WIDTH = 16
CHARACTER_HEIGHT = 20

characterDY = 0
CHARACTER_MOVE_SPEED = 40
JUMP_VELOCITY = -220
fallenDown = false

GRAVITY = 7

-- tiles
TILE_SIZE = 16
characterY = ((2) * TILE_SIZE) - CHARACTER_HEIGHT

TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4

TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10

TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 10

SKY = 2
GROUND = 1

-- map
mapWidth = 200 
mapHeight = 10

-- trophy
TROPHY_X = (mapWidth - 2) * TILE_SIZE

-- death block

deathX = 1
deathY = 0

-- timer
timer = 0
DELTA_COUNTDOWN = 0.2
timerCount = 1

gameTimer = 0
-- rocket
rTimer = 0
rTimerCount = 0
rCOUNTDOWN = math.random(2, 5)
rTable = {}
ROCKET_MOVE_SPEED = 5

-- rocketX = mapWidth - 1

boost = false

-- after game
GameEnd = false
score = 0
extraScore = 0
keysPressed = {}
winMessage = 'You Won!'


function love.load()
    
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Runner')
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
    
    math.randomseed(os.time())

    font = love.graphics.newFont('font.ttf')
    timerFont = love.graphics.newFont('font.ttf', 10)

    sounds = {
        ['jump'] = love.audio.newSource("sounds/jump.wav", "static"),
        ['death'] = love.audio.newSource("sounds/death.wav", "static"),
        ['victory'] = love.audio.newSource("sounds/victory.wav", "static"),
        ['select'] = love.audio.newSource("sounds/select.wav", "static")
    }

    rocketDeathMsg = {
        [1] = 'Remove yourself from the rocket',
        [2] = 'Your head was sliced open',
        [3] = 'The rocket scooped out your intestines',
        [4] = 'Your face caved inwards',
        [5] = 'You went SPLAT! on the nose-cone',
        [6] = 'The rocket exploded inside you',
        [7] = 'The fuel combusted inside you',
        [8] = 'The rocket does not like you'
    }

    deathBlockMsg = {
        [1] = 'You spontaneously combusted',
        [2] = 'Your innards went outwards',
        [3] = 'Your brains rotted',
        [4] = 'You melted',
        [5] = 'You evaporated',
        [6] = 'You were launched into orbit',
        [7] = 'You died because of your incompetence',
        [8] = 'You were eviscerated'
    }

    trophy = love.graphics.newImage('graphics/trophy.png')
    death_block = love.graphics.newImage('graphics/death_block.png')
    fireSheet = love.graphics.newImage('graphics/fire.png')
    rocketSheet = love.graphics.newImage('graphics/rockets.png')
    
    tilesheet = love.graphics.newImage('graphics/tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)
    
    characterSheet = love.graphics.newImage('graphics/characters.png')
    characterQuads = GenerateQuads(characterSheet, CHARACTER_WIDTH, CHARACTER_HEIGHT)

    topperSheet = love.graphics.newImage('graphics/tile_tops.png')
    topperQuads = GenerateQuads(topperSheet, TILE_SIZE, TILE_SIZE)

    fireQuads = GenerateQuads(fireSheet, TILE_SIZE, TILE_SIZE)
    rocketQuads = GenerateQuads(rocketSheet, TILE_SIZE, TILE_SIZE)

    tilesets = GenerateTileSets(quads, TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)
    toppersets = GenerateTileSets(topperQuads, TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

    tileset = math.random(#tilesets)
    topperset = math.random(#toppersets)
    
    idleAnimation = Animation {
        frames = {1},
        interval = 1
    }
    
    movingAnimation = Animation {
        frames = {2, 3},
        interval = 0.2
    }

    jumpAnimation = Animation {
        frames = {4},
        interval = 1
    }

    fireButtAnimation = Animation {
        frames = {5, 6},
        interval = 0.05
    }

    victoryAnimation = Animation {
        frames = {7},
        interval = 1
    }

    fireAnimation = Animation {
        frames = {1, 2, 3, 4},
        interval = 0.1
    }

    rocketAnimation = Animation {
        frames = {1, 2, 3, 4},
        interval = 0.1
    }
    
    currentAnimation = idleAnimation 
    
    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    
    direction = 'right'
    
    backgroundR = math.random(255)/100
    backgroundG = math.random(255)/100
    backgroundB = math.random(255)/100
    
    tiles = generateLevel()
    
end




function love.resize(w, h)
    push:resize(w, h)
end




function love.keypressed(key)

    keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    
    if not GameEnd then
        if (key == 'space' or key == 'up') and characterDY == 0 then
            characterDY = JUMP_VELOCITY
            currentAnimation = jumpAnimation
            sounds['jump']:play()
        end

        if key == 'b' then 
            bKey = true
        else
            bKey = false
        end

        if key == 'r' then 
            tileset = math.random(#tilesets)
            topperset = math.random(#toppersets)
        end
    
        --[[if key == 'd' then 
            characterX = (mapWidth * TILE_SIZE) - 60
            characterY = 1
        end]]--
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

    if not GameEnd then

        gameTimer = gameTimer + dt

        characterDY = math.min(220, (characterDY + GRAVITY))
        characterY = characterY + characterDY * dt

        jumped = (love.keyboard.wasPressed('space') or love.keyboard.wasPressed('up'))

        while bKey and jumped do                      -- timer = 0                                                
            currentAnimation = fireButtAnimation                -- DELTA_COUNTDOWN = 0.2 
            CHARACTER_MOVE_SPEED = 60                           -- timerCount = 1
            timer = timer + dt   
            
            if timer >= DELTA_COUNTDOWN then
                -- CHARACTER_MOVE_SPEED = 40   
                timer = 0
                jumped = false
                bKey = false
                break
            end 
        end
            

        rTimer = rTimer + dt
        if rTimer >= rCOUNTDOWN then
            table.insert(rTable, {
                ricket = rocketQuads,
                rocketX = mapWidth - 1,
                rocketY = math.random(1, 6) - 1
            })
            rTimer = 0
            rCOUNTDOWN = math.random(2, 5)
        end
        for k, rocket in pairs(rTable) do
            rocket.rocketX = rocket.rocketX - ROCKET_MOVE_SPEED * dt
            if characterX + 1 <= (rocket.rocketX * TILE_SIZE) - 1 + TILE_SIZE and characterX + CHARACTER_WIDTH - 1 >= (rocket.rocketX * TILE_SIZE) + 1 then
                if characterY <= (rocket.rocketY * TILE_SIZE) - 3 + TILE_SIZE and characterY + CHARACTER_HEIGHT >= (rocket.rocketY * TILE_SIZE) + 5 then 
                    characterDY = 0
                    keysPressed = {}
                    winMessage = rocketDeathMsg[math.random(1, 8)]
                    rTable = {}
                    GameEnd = true
                    sounds['death']:play()
                end
            end
            if rocket.rocketX <= 0 then
                table.remove(rTable, k)
            end
        end



        -- bottom right
        if tiles[math.floor((characterY + CHARACTER_HEIGHT) / TILE_SIZE) + 1][math.floor((characterX + (CHARACTER_WIDTH - 6)) / TILE_SIZE) + 1].id == 1 then
            if tiles[math.floor((characterY + CHARACTER_HEIGHT) / TILE_SIZE) + 1][math.floor((characterX + (CHARACTER_WIDTH - 6)) / TILE_SIZE) + 1].deadly then
                characterDY = 0
                keysPressed = {}
                rTable = {}
                winMessage = deathBlockMsg[math.random(1, 8)]
                GameEnd = true
                sounds['death']:play()
            end
            timer = 0
            CHARACTER_MOVE_SPEED = 40
            currentAnimation = movingAnimation
            characterY =  ((math.floor(characterY / TILE_SIZE) + 1) * TILE_SIZE) - 4
            characterDY = 0
        end

        -- bottom left
        if tiles[math.floor((characterY + CHARACTER_HEIGHT) / TILE_SIZE) + 1][math.floor((characterX + 5) / TILE_SIZE) + 1].id == 1 then
            if tiles[math.floor((characterY + CHARACTER_HEIGHT) / TILE_SIZE) + 1][math.floor((characterX + 5) / TILE_SIZE) + 1].deadly then
                characterDY = 0
                keysPressed = {}
                rTable = {}
                winMessage = deathBlockMsg[math.random(1, 8)]
                GameEnd = true
                sounds['death']:play()
            end
            characterY =  ((math.floor(characterY / TILE_SIZE) + 1) * TILE_SIZE) - 4
            characterDY = 0
        end

        -- right
        if (tiles[math.floor((characterY + CHARACTER_HEIGHT/2 )/ TILE_SIZE) + 1][math.floor((characterX + CHARACTER_WIDTH) / TILE_SIZE) + 1].id == 1) then
            characterX = ((math.floor((characterX - CHARACTER_WIDTH)/ TILE_SIZE) + 1) * TILE_SIZE)
        end

        --left
        if (tiles[math.floor((characterY + CHARACTER_HEIGHT/2 )/ TILE_SIZE) + 1][math.floor((characterX) / TILE_SIZE) + 1].id == 1) then
            characterX = ((math.floor((characterX)/ TILE_SIZE) + 1) * TILE_SIZE)
        end

        -- trophy collision
        if characterX <= TROPHY_X + TILE_SIZE and characterX + CHARACTER_WIDTH >= TROPHY_X then
            if characterY <= TROPHY_Y + TILE_SIZE and characterY + CHARACTER_HEIGHT >= TROPHY_Y then
                winFrame = true
                keysPressed = {}
                rTable = {}
                winMessage = 'You Won!'
                extraScore = 50
                GameEnd = true
                sounds['victory']:play()
            end
        end
        

        currentAnimation:update(dt)
        fireAnimation:update(dt)
        rocketAnimation:update(dt)
        
        -- camera scroll based on user input
        if love.keyboard.isDown('left') then
            characterX = characterX - CHARACTER_MOVE_SPEED * dt
            
            if characterDY == 0 then
                currentAnimation = movingAnimation
            end
            
            direction = 'left'
        elseif love.keyboard.isDown('right') then
            characterX = characterX + CHARACTER_MOVE_SPEED * dt
            
            if characterDY == 0 then
                currentAnimation = movingAnimation
            end
            
            direction = 'right'
        else
            currentAnimation = idleAnimation
        end

        -- upper border
        -- chasm death
        -- left border
        -- right border
        if characterY <= 0 then
            characterY = math.max(0, characterY)
            characterDY = 0
        elseif characterY + CHARACTER_HEIGHT >= 142 then
            characterDY = 0
            keysPressed = {}
            rTable = {}
            winMessage = 'You burned!'
            GameEnd = true
            sounds['death']:play()
        elseif characterX <= 0 then
            characterX = 0
        elseif characterX >= (mapWidth * TILE_SIZE) - CHARACTER_WIDTH then
            characterX = (mapWidth * TILE_SIZE) - CHARACTER_WIDTH - 1
        end
    end
    

    -- set the camera's left edge to half the screen to the left of the player's center
    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)

    if GameEnd then 
    
        score = math.floor(characterX / TILE_SIZE) + extraScore
        
        for k, v in pairs(tiles) do
            table.remove(tiles, k)
        end
        
        for y = 1, mapHeight do
            table.insert(tiles, {})
            
            for x = 1, mapWidth do
                table.insert(tiles[y], {
                    id = SKY,
                    topper = false
                })
            end
        end
        
        if not winFrame then
            currentAnimation = idleAnimation
        else
            currentAnimation = victoryAnimation
        end

        direction = 'right'
        characterY = VIRTUAL_HEIGHT/2 - CHARACTER_WIDTH

        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            highlighted = highlighted == 1 and 2 or 1
            sounds['select']:play()
        end

        if highlighted == 1 and (love.keyboard.wasPressed('shift') or love.keyboard.wasPressed('return')) then
            GameEnd = false
            winFrame = false
            gameTimer = 0
            score = 0
            characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
            characterY = ((2) * TILE_SIZE) - CHARACTER_HEIGHT
            currentAnimation = idleAnimation 
            direction = 'right'
            tileset = math.random(#tilesets)
            topperset = math.random(#toppersets)
            tiles = generateLevel()
            backgroundR = math.random(255)/100
            backgroundG = math.random(255)/100
            backgroundB = math.random(255)/100
        elseif highlighted == 2 and (love.keyboard.wasPressed('shift') or love.keyboard.wasPressed('return')) then
            love.event.quit()
        end

        keysPressed = {}
    end
end









function love.draw()
    push:start()
    love.graphics.translate(-math.floor(cameraScroll), 0)
    love.graphics.clear(backgroundR, backgroundG, backgroundB, 0.8)

    if not GameEnd then
        for y = 1, mapHeight do
            for k, fireX in pairs(fireXtiles) do
                love.graphics.draw(fireSheet, fireQuads[fireAnimation:getCurrentFrame()], (fireX - 1) * TILE_SIZE, (mapHeight - 2) * TILE_SIZE)
            end

            for x = 1, mapWidth do

                local tile = tiles[y][x]
                love.graphics.draw(tilesheet, tilesets[tileset][tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
                
                if tile.topper then
                    love.graphics.draw(topperSheet, toppersets[topperset][tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
                end
                
                if tile.deadly then
                    love.graphics.draw(death_block, (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
                end
            end
        end


        for k, rocketDraw in pairs(rTable) do
            love.graphics.draw(rocketSheet, rocketDraw.ricket[rocketAnimation:getCurrentFrame()], rocketDraw.rocketX * TILE_SIZE, rocketDraw.rocketY * TILE_SIZE)
        end
        love.graphics.draw(trophy, TROPHY_X, TROPHY_Y)
    end
    
    --[[ draw character, current frame from Animation class
    check for direction and scale by -1 on the X axis if facing left
    when scaled by -1, set origin to center of sprite as well for proper flipping]]--
    
    love.graphics.draw(characterSheet, characterQuads[currentAnimation:getCurrentFrame()],
    
    -- X and Y we draw at shifted by half width and height cuz setting origin to centre
    -- for proper scaling, reverse-shifts rendering
    math.floor(characterX) + CHARACTER_WIDTH / 2, math.floor(characterY) + CHARACTER_HEIGHT / 2,
    
    -- 0 rotation, then the X and Y scales
    0, direction == "left" and -1 or 1, 1,
    
    -- offset
    CHARACTER_WIDTH / 2, CHARACTER_HEIGHT / 2)
    
    if GameEnd then

        if winFrame then
            love.graphics.draw(trophy, characterX + TILE_SIZE - 1, characterY + 10)
        end

        love.graphics.setFont(font)
        
        love.graphics.printf(winMessage, characterX - (VIRTUAL_WIDTH/2 + CHARACTER_WIDTH/2) + 18, 8, VIRTUAL_WIDTH, 'center')
        
        love.graphics.printf('Score : ' .. tostring(score) .. '   Time : ' .. tostring(round(gameTimer, 2)), characterX - (VIRTUAL_WIDTH/2 + CHARACTER_WIDTH/2) + 18, characterY - 18, VIRTUAL_WIDTH, 'center')
        if highlighted == 1 then
            love.graphics.setColor(0.4, 1, 1, 1)
        end
    
        love.graphics.printf('Restart', characterX - (VIRTUAL_WIDTH/2 + CHARACTER_WIDTH/2) + 18, VIRTUAL_HEIGHT * 3 / 4, VIRTUAL_WIDTH, 'center')
    
        love.graphics.setColor(1, 1, 1, 1)
    
        if highlighted == 2 then
            love.graphics.setColor(0.4, 1, 1, 1)
        end
    
        love.graphics.printf('Exit', characterX - (VIRTUAL_WIDTH/2 + CHARACTER_WIDTH/2) + 18, VIRTUAL_HEIGHT * 3 / 4 + 20, VIRTUAL_WIDTH, 'center')
    
        love.graphics.setColor(1, 0.7, 0.3, 1)
    end
    push:finish()
end




function round(number, dplaces)
    local v = number * (10^dplaces)
    local n = math.floor(v)
    return n/(10^dplaces)
end




function generateLevel()
    tiles = {}
    fireXtiles = {}
    local n = 1
    
    for y = 1, mapHeight do
        table.insert(tiles, {})
        
        for x = 1, mapWidth do
            table.insert(tiles[y], {
                id = SKY,
                topper = false
            })
        end
    end

    for x=1, mapWidth do 

        if math.random(7) == 1 and x > 10 and (x < mapWidth - 1 )then
            table.insert(fireXtiles, x)
            goto continue
        end

        local spawnPillar = math.random(3) == 1
        local pillarHeight = math.random(4, 6)
        local spawnDeath = math.random(10) == 1
        
        if spawnPillar then 
            for pillar = pillarHeight, 6 do
                tiles[pillar][x] = {
                    id = GROUND,
                    topper = pillar == pillarHeight and true or false,
                    deadly = spawnDeath
                }
            end
        end
        
        for ground = 7, mapHeight do
            tiles[ground][x] = {
                id = GROUND,
                topper = (not spawnPillar and ground == 7) and true or false
            }
        end 
        
        ::continue::
    end
    
    for y=3, 7 do
        if tiles[y][mapWidth - 1].id == 1 then 
            TROPHY_Y = (y - 2) * TILE_SIZE
            break
        end
    end
    return tiles, fireXtiles
end