local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Turret = class('Turret', Entity)

function Turret:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.firingSpeed = args.firingSpeed
    self.bulletSpeed = args.bulletSpeed
    turretImage = love.graphics.newImage("image/ship_1.png")
    self.shouldTrackPlayer = args.shouldTrackPlayer
    self.rotation = args.startAngle or 0
    self.timeSinceLastShot = 0
end

function Turret:draw()
    love.graphics.draw(turretImage, self.x, self.y, self.rotation, 2, 2, turretImage:getWidth() / 2, turretImage:getHeight() / 2)
end

function Turret:update(dt)
    if self.shouldTrackPlayer then
        self.rotation = self:getRadiansTowardPlayer() - 1.58
    end

    self.timeSinceLastShot = self.timeSinceLastShot + dt

    if self.timeSinceLastShot > self.firingSpeed then
        self.timeSinceLastShot = 0
        table.insert(bullets, self:fire())
    end
end

function Turret:fire()
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

    local bullet = Bullet:new(self.x - velx * 20, self.y - vely * 20)
    bullet:getBox():applyLinearImpulse(-velx * self.bulletSpeed, -vely * self.bulletSpeed)
    return bullet
end

function Turret:getRadiansTowardPlayer()
    local x, y = self:getVectorTowardPlayer()
    return math.atan2(y, x)
end

function Turret:getVectorTowardPlayer()
    local vectorXTowardPlayer = self.x - player:getX()
    local vectorYTowardPlayer = self.y - player:getY()
    return vectorXTowardPlayer, vectorYTowardPlayer
end

return Turret
