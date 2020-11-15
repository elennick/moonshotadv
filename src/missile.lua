local class = require 'libs.middleclass'
local wf = require 'libs.windfield'
local Entity = require 'src.entity'

Missile = class('Missile', Entity)

function Missile:initialize(x, y, projectileSpeed)
    Entity.initialize(self, x, y)
    self.timeAlive = 0
    self.timeSinceLastImpulse = 0
    self.rotation = self:getRadiansTowardPlayer() - 1.58
    self.projectileSpeed = projectileSpeed

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

    if self.timeSinceLastImpulse > .1 then
        self.timeSinceLastImpulse = 0
        local velx, vely = self:getVectorTowardPlayer()

        --move towards player
        local length = math.sqrt(velx * velx + vely * vely);
        if length ~= 0 then
            velx = velx / length;
            vely = vely / length;
        end
        self:getBox():applyLinearImpulse(-velx * self.projectileSpeed, -vely * self.projectileSpeed)

        --point towards player
        self.rotation = self:getRadiansTowardPlayer() - 1.58
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
