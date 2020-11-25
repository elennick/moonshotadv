local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local wf = require 'libs.windfield'
local Entity = require 'src.entity'

Bullet = class('Bullet', Entity)

function Bullet:initialize(x, y)
    Entity.initialize(self, x, y)
    self.w = 10
    self.h = 10
    self.timeAlive = 0

    self.collider = world:newCircleCollider(x, y, 3)
    self.collider:setCollisionClass('Bullet')
    self.collider:setRestitution(1)

    gunSound:clone():play()
end

function Bullet:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle('line', self.x, self.y, 4)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', self.x, self.y, 3)
end

function Bullet:update(dt)
    self.timeAlive = self.timeAlive + dt

    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Bullet:getBox()
    return self.collider
end

function Bullet:getTimeAlive()
    return self.timeAlive
end

function Bullet:destroy(i)
    self:getBox():destroy()
    table.remove(bullets, i)
end

return Bullet
