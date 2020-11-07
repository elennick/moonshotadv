local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local wf = require 'libs.windfield'

Player = class('Player')

function Player:initialize(x, y, rotation)
    self.x = x
    self.y = y
    self.w = 32
    self.h = 32
    self.rotation = rotation

    playerIdleSpriteSheet = love.graphics.newImage("image/characters/elise_idle.png")
    playerIdleFrames = anim8.newGrid(32, 32, playerIdleSpriteSheet:getWidth(), playerIdleSpriteSheet:getHeight())
    playerIdleAnimation = anim8.newAnimation(playerIdleFrames('1-3', 1), 0.2)

    playerWalkSpriteSheet = love.graphics.newImage("image/characters/elise_walk.png")
    playerWalkFrames = anim8.newGrid(32, 32, playerWalkSpriteSheet:getWidth(), playerWalkSpriteSheet:getHeight())
    playerWalkAnimation = anim8.newAnimation(playerWalkFrames('1-3', 1), 0.15)

    world:addCollisionClass('Player')
    self.collider = world:newBSGRectangleCollider(x, y, 32, 32, 8)
    self.collider:setCollisionClass('Player')
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)
    if isMovingRight then
        playerWalkAnimation:draw(playerWalkSpriteSheet, self.x, self.y, self.rotation, 3, 3, self.w / 2, self.h / 2)
    elseif isMovingLeft then
        playerWalkAnimation:draw(playerWalkSpriteSheet, self.x, self.y, self.rotation, -3, 3, self.w / 2, self.h / 2)
    else
        playerIdleAnimation:draw(playerIdleSpriteSheet, self.x, self.y, self.rotation, 3, 3, self.w / 2, self.h / 2)
    end
end

function Player:update(dt, playerRotationInRadians)
    playerIdleAnimation:update(dt)
    playerWalkAnimation:update(dt)

    self.x = self.collider:getX() + 4
    self.y = self.collider:getY()

    self.rotation = playerRotationInRadians - 1.65
    print('rotation in radians ' .. self.rotation)
end

function Player:applyLinearImpulse(x, y)
    self.collider:applyLinearImpulse(x, y)
end

function Player:getX()
    return self.x
end

function Player:getY()
    return self.y
end

function Player:getCoords()
    return self.x, self.y
end

function Player:getBox()
    return self.collider
end

return Player
