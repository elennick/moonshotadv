local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'

AnimatedPlanet = class('AnimatedPlanet')

function AnimatedPlanet:initialize(x, y, size, spriteSheet, collisionClass)
    self.x = x
    self.y = y
    self.size = size
    self.spriteSheet = spriteSheet

    self.frames = anim8.newGrid(34, 34, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.frames('1-15', 1, '1-15', 2, '1-15', 3, '1-15', 4, '1-4', 5), 0.25)

    world:addCollisionClass(collisionClass)
    self.collider = world:newCircleCollider(self.x, self.y, size)
    self.collider:setType('static')
    --self.collider:setFriction(0)
    self.collider:setCollisionClass(collisionClass)
end

function AnimatedPlanet:draw()
    self.animation:draw(self.spriteSheet, self.x, self.y, 0, self.size, self.size)
end

function AnimatedPlanet:update(dt)
    self.animation:update(dt)
end

function AnimatedPlanet:getX()
    return self.x
end

function AnimatedPlanet:getY()
    return self.y
end

function AnimatedPlanet:getCoords()
    return self.x, self.y
end

function AnimatedPlanet:getBox()
    return self.collider
end

function AnimatedPlanet:getSize()
    return self.size
end

return AnimatedPlanet
