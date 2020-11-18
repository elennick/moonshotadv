local class = require 'libs.middleclass'
local wf = require 'libs.windfield'
local anim8 = require 'libs.anim8'
local Entity = require 'src.entity'

Missile = class('Missile', Entity)

Missile.static.baseMaxSpeed = 50

function Missile:initialize(x, y, projectileSpeed)
    Entity.initialize(self, x, y)
    self.timeAlive = 0
    self.timeSinceLastImpulse = 0
    self.rotation = self:getRadiansTowardPlayer() - 1.58
    self.projectileSpeed = projectileSpeed

    self.image = love.graphics.newImage("image/rocket.png")
    self.exhaustSpriteSheet = love.graphics.newImage("image/exhaust.png")
    local exhaustFrames = anim8.newGrid(64, 64, self.exhaustSpriteSheet:getWidth(), self.exhaustSpriteSheet:getHeight())
    self.exhaustAnimation = anim8.newAnimation(exhaustFrames('1-4', 1), 0.1)

    self.maxSpeed = Missile.baseMaxSpeed * self.projectileSpeed

    self.collider = world:newCircleCollider(x, y, 10)
    self.collider:setCollisionClass('Missile')
end

function Missile:draw()
    --use push/pop coordinate system stuff so that we can rotate the missile and the exhaust together as one graphic
    love.graphics.push("all")
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation + 1.5)
    self.exhaustAnimation:draw(self.exhaustSpriteSheet, 22, 0, 0, .4, .4, 64 / 2, 64 / 2)
    love.graphics.draw(self.image,
            0,
            0,
            -1.58,
            self.size,
            self.size,
            self.image:getWidth() / 2,
            self.image:getHeight() / 2)
    love.graphics.pop()
end

function Missile:update(dt)
    self.exhaustAnimation:update(dt)

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

        --if speed is now over max, clamp it back
        --TODO this needs work, clamping only one vector value at a time creates weird acceleration behavior
        local lvx, lvy = self:getBox():getLinearVelocity()
        self:getBox():setLinearVelocity(self:clampMaxVelocity(lvx), self:clampMaxVelocity(lvy))

        --point towards player
        self.rotation = self:getRadiansTowardPlayer() - 1.58
    end
end

function Missile:clampMaxVelocity(vel)
    if vel > self.maxSpeed then
        vel = self.maxSpeed
    elseif vel < -self.maxSpeed then
        vel = -self.maxSpeed
    end
    return vel
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
