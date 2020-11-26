local class = require 'libs.middleclass'
local Entity = require 'src.entity'

LockedGate = class('LockedGate', Entity)

function LockedGate:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.direction = args.direction

    if self.direction == 'horizontal' then
        self.rotation = 0
    else
        self.rotation = 1.58
    end

    self.keyholeImage = love.graphics.newImage("image/lock.png")
    self.wallImage = love.graphics.newImage("image/wall.png")

    if self.direction == 'horizontal' then
        self.collider = world:newRectangleCollider(self.x, self.y, 80, 16)
    else
        self.collider = world:newRectangleCollider(self.x - 16, self.y, 16, 80)
    end

    self.collider:setCollisionClass('LockedGate')
    self.collider:setType('static')
    self.collider:setFriction(0)

    self.clonedUnlockSound = unlockSound:clone()
end

function LockedGate:draw()
    love.graphics.push("all")
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)

    love.graphics.draw(self.keyholeImage, 0, 0, 0, .5, .5)
    love.graphics.draw(self.keyholeImage, 16, 0, 0, .5, .5)
    love.graphics.draw(self.keyholeImage, 32, 0, 0, .5, .5)
    love.graphics.draw(self.keyholeImage, 48, 0, 0, .5, .5)
    love.graphics.draw(self.keyholeImage, 64, 0, 0, .5, .5)

    love.graphics.pop()
end

function LockedGate:update(dt)
    if self.collider:enter('Player') and player:getNumOfKeysInInventory() > 0 then
        self.clonedUnlockSound:play()
        player:removeKeyFromInventory()
        self.collider:destroy()
        lockedGates = {}
    end
end

function LockedGate:getBox()
    return self.collider
end

return LockedGate
