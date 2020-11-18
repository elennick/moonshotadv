local class = require 'libs.middleclass'
local Entity = require 'src.entity'

RotatingPlanet = class('RotatingPlanet', Entity)

RotatingPlanet.static.maxRotationSpeed = .5

function RotatingPlanet:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.size = args.size
    self.rotationSpeed = args.rotationSpeed
            or math.random(-RotatingPlanet.maxRotationSpeed, RotatingPlanet.maxRotationSpeed)
    self.rotation = love.math.random(359)
    self.type = args.type

    if self.rotationSpeed == nil then
        self.rotationSpeed = math.random(-RotatingPlanet.maxRotationSpeed, RotatingPlanet.maxRotationSpeed)
    end

    if self.type == 'lava' then
        self.image = love.graphics.newImage("image/planets/Lava.png")
    elseif self.type == 'moon' then
        self.image = love.graphics.newImage("image/planets/Baren.png")
    elseif self.type == 'ice' then
        self.image = love.graphics.newImage("image/planets/Ice.png")
    elseif self.type == 'earth' then
        self.image = love.graphics.newImage("image/planets/Terran.png")
    elseif self.type == 'mech' then
        self.image = love.graphics.newImage("image/planets/CO-MechPlanet.png")
    end

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

function RotatingPlanet:getType()
    return self.type
end

return RotatingPlanet
