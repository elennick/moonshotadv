local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local wf = require 'libs.windfield'
local Entity = require 'src.entity'

Player = class('Player', Entity)

function Player:initialize(x, y)
    Entity.initialize(self, x, y)
    self.w = 32
    self.h = 32
    self.rotation = 0
    self.keysInInventory = 0

    playerIdleSpriteSheet = love.graphics.newImage("image/elise_idle.png")
    playerIdleFrames = anim8.newGrid(32, 32, playerIdleSpriteSheet:getWidth(), playerIdleSpriteSheet:getHeight())
    playerIdleAnimation = anim8.newAnimation(playerIdleFrames('1-3', 1), 0.2)

    playerWalkSpriteSheet = love.graphics.newImage("image/elise_walk.png")
    playerWalkFrames = anim8.newGrid(32, 32, playerWalkSpriteSheet:getWidth(), playerWalkSpriteSheet:getHeight())
    playerWalkAnimation = anim8.newAnimation(playerWalkFrames('1-3', 1), 0.15)

    self.collider = world:newRectangleCollider(x, y, 32, 32)
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
end

function Player:applyLinearImpulse(x, y)
    self.collider:applyLinearImpulse(x, y)
end

function Player:getBox()
    return self.collider
end

function Player:destroy()
    self.collider:destroy()
end

function Player:addKeyToInventory()
    self.keysInInventory = self.keysInInventory + 1
end

function Player:removeKeyFromInventory()
    self.keysInInventory = self.keysInInventory - 1
end

function Player:getNumOfKeysInInventory()
    return self.keysInInventory
end
return Player
