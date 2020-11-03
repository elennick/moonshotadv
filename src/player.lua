local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'

Player = class('Player')

function Player:initialize(x, y)
    self.x = x
    self.y = y
    self.w = 32
    self.h = 32

    playerIdleSpriteSheet = love.graphics.newImage("image/characters/elise_idle.png")
    playerIdleFrames = anim8.newGrid(32, 32, playerIdleSpriteSheet:getWidth(), playerIdleSpriteSheet:getHeight())
    playerIdleAnimation = anim8.newAnimation(playerIdleFrames('1-3', 1), 0.2)

    playerWalkSpriteSheet = love.graphics.newImage("image/characters/elise_walk.png")
    playerWalkFrames = anim8.newGrid(32, 32, playerWalkSpriteSheet:getWidth(), playerWalkSpriteSheet:getHeight())
    playerWalkAnimation = anim8.newAnimation(playerWalkFrames('1-3', 1), 0.15)
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    if not isMoving then
        playerIdleAnimation:draw(playerIdleSpriteSheet, self.x, self.y, 0, 3, 3, self.w / 2, self.h / 2)
    else
        playerWalkAnimation:draw(playerWalkSpriteSheet, self.x, self.y, 0, 3, 3, self.w / 2, self.h / 2)
    end
end

function Player:update(dt)
    playerIdleAnimation:update(dt)
    playerWalkAnimation:update(dt)

    isMoving = false
    if love.keyboard.isDown("right") then
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        isMoving = true
    end
end

return Player
