local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'

AnimatedPlanet = class('AnimatedPlanet')

function AnimatedPlanet:initialize(x, y, size, spriteSheet)
    self.x = x
    self.y = y
    self.size = size
    self.spriteSheet = spriteSheet

    self.frames = anim8.newGrid(34, 34, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.frames('1-15', 1, '1-15', 2, '1-15', 3, '1-15', 4, '1-4', 5), 0.25)
end

function AnimatedPlanet:draw()
    self.animation:draw(self.spriteSheet, self.x, self.y, 0, self.size, self.size)
end

function AnimatedPlanet:update(dt)
    self.animation:update(dt)
end

return AnimatedPlanet
