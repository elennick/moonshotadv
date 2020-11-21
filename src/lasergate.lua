local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local Entity = require 'src.entity'

LaserGate = class('LaserGate', Entity)

function LaserGate:initialize(x, y)
    Entity.initialize(self, x, y)

    self.spriteSheet = love.graphics.newImage("image/lasers-spritesheet.png")
    self.frames = anim8.newGrid(14, 85, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.frames('1-24', 1), 0.1)
end

function LaserGate:draw()
    self.animation:draw(self.spriteSheet, self.x, self.y)
end

function LaserGate:update(dt)
    self.animation:update(dt)
end

return LaserGate
