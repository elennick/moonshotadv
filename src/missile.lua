local class = require 'libs.middleclass'
local wf = require 'libs.windfield'
local Entity = require 'src.entity'

Missile = class('Missile', Entity)

function Missile:initialize(x, y)
    Entity.initialize(self, x, y)
    self.timeAlive = 0
    self.timeSinceLastImpulse = 0

    self.image = love.graphics.newImage("image/rocket.png")

    self.collider = world:newCircleCollider(x, y, 3)
    self.collider:setCollisionClass('Missile')
end

function Missile:draw()
    love.graphics.draw(self.image,
            self.x,
            self.y,
            self.rotation,
            self.size,
            self.size,
            self.image:getWidth() / 2,
            self.image:getHeight() / 2)
end

function Missile:update(dt)
    self.timeAlive = self.timeAlive + dt
    self.timeSinceLastImpulse = self.timeSinceLastImpulse + dt

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.timeSinceLastImpulse > .5 then
        velx, vely = self:getVectorTowardPlayer()
        self:getBox():applyLinearImpulse(-velx / 75, -vely / 75)
        self.timeSinceLastImpulse = 0
    end
end

function Missile:getBox()
    return self.collider
end

function Missile:getTimeAlive()
    return self.timeAlive
end

function Missile:destroy(i)
    self:getBox():destroy()
    table.remove(missiles, i)
end

return Missile
