local class = require 'libs.middleclass'

RotatingPlanet = class('RotatingPlanet')

function RotatingPlanet:initialize(x, y, size, image, rotationSpeed, collisionClass)
    self.x = x
    self.y = y
    self.size = size
    self.image = image
    self.rotationSpeed = rotationSpeed
    self.collisionClass = collisionClass
    self.rotation = love.math.random(359)

    world:addCollisionClass(collisionClass)
    self.collider = world:newCircleCollider(self.x, self.y, size * 24)
    self.collider:setType('static')
    self.collider:setFriction(0.25)
    self.collider:setCollisionClass(collisionClass)
end

function RotatingPlanet:draw()
    love.graphics.draw(self.image,
            self.x, self.y,
            self.rotation,
            self.size, self.size,
            self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function RotatingPlanet:update(dt)
    self.rotation = self.rotation + (self.rotationSpeed * dt)
    if self.rotation > 360 then
        self.rotation = 0
    end
end

function RotatingPlanet:getCollisionClass()
    return self.collisionClass
end

function RotatingPlanet:getX()
    return self.x
end

function RotatingPlanet:getY()
    return self.y
end

function RotatingPlanet:getCoords()
    return self.x, self.y
end

function RotatingPlanet:getBox()
    return self.collider
end

function RotatingPlanet:getSize()
    return self.size
end

return RotatingPlanet
