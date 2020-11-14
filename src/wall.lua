local wf = require 'libs.windfield'
local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Wall = class('Wall', Entity)

function Wall:initialize(args)
    Entity.initialize(self, args.x, args.y)
    self.w = args.w
    self.h = args.h

    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass('Wall')
    self.collider:setType('static')
    --self.collider:setLinearDamping(0, 0)
    --self.collider:setAngularDamping(0)
    self.collider:setFriction(0)
end

function Wall:draw()
    love.graphics.setColor(.5, .5, .5, 1)
    love.graphics.rectangle('fill', self.x + 1, self.y + 1, self.w - 2, self.h - 2, 2, 2)
    love.graphics.setColor(.2, .2, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, 2, 2)
end

function Wall:update(dt)
end

function Wall:getBox()
    return self.collider
end

return Wall
