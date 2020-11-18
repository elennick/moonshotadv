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
    self.collider:setFriction(0)

    self.image = love.graphics.newImage("image/wall.png")
    self.image:setWrap("repeat", "repeat")
    self.quad = love.graphics.newQuad(32, 32, self.w, self.h, self.image:getDimensions())
end

function Wall:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y, self.rotation)
end

function Wall:update(dt)
end

function Wall:getBox()
    return self.collider
end

return Wall
