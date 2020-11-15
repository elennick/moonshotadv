local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Turret = class('Turret', Entity)

function Turret:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.firingSpeed = args.firingSpeed
    self.projectileSpeed = args.projectileSpeed
    self.type = args.type
    self.shouldTrackPlayer = args.shouldTrackPlayer
    self.rotation = args.startAngle or 0
    self.timeSinceLastShot = 0

    self.turretImage = love.graphics.newImage("image/ship_1.png")
end

function Turret:draw()
    love.graphics.draw(self.turretImage, self.x, self.y, self.rotation, 2, 2, self.turretImage:getWidth() / 2, self.turretImage:getHeight() / 2)
end

function Turret:update(dt)
    if self.shouldTrackPlayer then
        self.rotation = self:getRadiansTowardPlayer() - 1.58
    end

    self.timeSinceLastShot = self.timeSinceLastShot + dt

    if self.timeSinceLastShot > self.firingSpeed then
        self.timeSinceLastShot = 0

        if self.type == 'bullet' then
            table.insert(bullets, self:fireBullet())
        else
            table.insert(missiles, self:fireMissile())
        end
    end
end

function Turret:fireBullet()
    local velx, vely = self:getVelocityOfNextProjectile()
    local bullet = Bullet:new(self.x - velx * 20, self.y - vely * 20)
    bullet:getBox():applyLinearImpulse(-velx * self.projectileSpeed, -vely * self.projectileSpeed)
    return bullet
end

function Turret:fireMissile()
    local velx, vely = self:getVelocityOfNextProjectile()
    local missile = Missile:new(self.x - velx * 20, self.y - vely * 20, self.projectileSpeed)
    missile:getBox():applyLinearImpulse(-velx * self.projectileSpeed, -vely * self.projectileSpeed)
    return missile
end

function Turret:getVelocityOfNextProjectile()
    local velx, vely
    if self.shouldTrackPlayer then
        velx, vely = self:getVectorTowardPlayer()
        local length = math.sqrt(velx * velx + vely * vely);
        if length ~= 0 then
            velx = velx / length;
            vely = vely / length;
        end
    else
        velx = math.cos(self.rotation + 1.58)
        vely = math.sin(self.rotation + 1.58)
    end
    return velx, vely
end

return Turret
