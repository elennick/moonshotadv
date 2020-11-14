local class = require 'libs.middleclass'
local Entity = require 'src.entity'

RotatingPlanet = class('RotatingPlanet', Entity)

function RotatingPlanet:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.size = args.size
    self.image = args.image
    self.rotationSpeed = args.rotationSpeed
    self.rotation = love.math.random(359)

    self.collider = world:newCircleCollider(self.x, self.y, self.size * 24)
    self.collider:setType('static')
    self.collider:setFriction(0.25)
    self.collider:setCollisionClass('Planet')
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

function RotatingPlanet:getBox()
    return self.collider
end

function RotatingPlanet:getSize()
    return self.size
end

return RotatingPlanet
