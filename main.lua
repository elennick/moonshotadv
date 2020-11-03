local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'

require 'src.player'

function love.load()
    math.randomseed(os.time())
    local major, minor, revision, codename = love.getVersion()
    print("running with LÖVE version: " .. major .. "." .. minor .. "." .. revision .. " " .. codename)

    playerIdleSpriteSheet = love.graphics.newImage("image/characters/elise_idle.png")
    playerIdleFrames = anim8.newGrid(32, 32, playerIdleSpriteSheet:getWidth(), playerIdleSpriteSheet:getHeight())
    playerIdleAnimation = anim8.newAnimation(playerIdleFrames('1-3', 1), 0.2)

    playerWalkSpriteSheet = love.graphics.newImage("image/characters/elise_walk.png")
    playerWalkFrames = anim8.newGrid(32, 32, playerWalkSpriteSheet:getWidth(), playerWalkSpriteSheet:getHeight())
    playerWalkAnimation = anim8.newAnimation(playerWalkFrames('1-3', 1), 0.15)

    planet1SpriteSheet = love.graphics.newImage("image/planets/Purple Planet.png")
    planet1Frames = anim8.newGrid(34, 34, planet1SpriteSheet:getWidth(), planet1SpriteSheet:getHeight())
    planet1Animation = anim8.newAnimation(planet1Frames('1-15', 1, '1-15', 2, '1-15', 3, '1-15', 4, '1-4', 5), 0.25)

    planet2SpriteSheet = love.graphics.newImage("image/planets/Green Planet.png")
    planet2Frames = anim8.newGrid(34, 34, planet2SpriteSheet:getWidth(), planet2SpriteSheet:getHeight())
    planet2Animation = anim8.newAnimation(planet2Frames('1-15', 1, '1-15', 2, '1-15', 3, '1-15', 4, '1-4', 5), 0.25)

    bgSpriteSheet = love.graphics.newImage("image/space/space9_4-frames.png")
    bgFrames = anim8.newGrid(320, 320, bgSpriteSheet:getWidth(), bgSpriteSheet:getHeight())
    bgAnimation = anim8.newAnimation(bgFrames('1-4', 1), 0.5)

    player = Player:new(0, 0)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, .4)
    bgAnimation:draw(bgSpriteSheet, 0, 0, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 320, 0, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 640, 0, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 960, 0, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 0, 320, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 320, 320, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 640, 320, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 960, 320, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 0, 640, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 320, 640, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 640, 640, 0, 1, 1)
    bgAnimation:draw(bgSpriteSheet, 960, 640, 0, 1, 1)

    love.graphics.setColor(1, 1, 1, 1)
    if not isMoving then
        playerIdleAnimation:draw(playerIdleSpriteSheet, 32, 32, 0, 3, 3)
    else
        playerWalkAnimation:draw(playerWalkSpriteSheet, 32, 32, 0, 3, 3)
    end
    planet1Animation:draw(planet1SpriteSheet, 32, 256, 0, 5, 5)
    planet2Animation:draw(planet2SpriteSheet, 32, 450, 0, 5, 5)
end

function love.update(dt)
    bgAnimation:update(dt)
    playerIdleAnimation:update(dt)
    playerWalkAnimation:update(dt)
    planet1Animation:update(dt)
    planet2Animation:update(dt)

    isMoving = false
    if love.keyboard.isDown("right") then
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        isMoving = true
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end
