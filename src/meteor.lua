local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Meteor = class('Meteor', Entity)

function Meteor:initialize()
    Entity.initialize(self, -25, love.math.random(25, 700))
    self.rotation = love.math.random(1, 359)

    self.image = love.graphics.newImage("image/meteor3.png")
    self.collider = world:newCircleCollider(self.x, self.y, 15)
    self.collider:setCollisionClass('Meteor')
    self.collider:applyLinearImpulse(love.math.random(25, 200), love.math.random(-20, 20))
end

function Meteor:draw()
    love.graphics.draw(self.image, self.collider:getX(), self.collider:getY(), self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Meteor:update(dt)
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.rotation = self.rotation + dt
end

function Meteor:destroy()
    self.collider:destroy()
end

function Meteor:getX()
    return self.x
end

return Meteor
