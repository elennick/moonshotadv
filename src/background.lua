local class = require 'libs.middleclass'
local anim8 = require 'libs.anim8'

Background = class('Background')

function Background:initialize()
    self.spriteSheet = love.graphics.newImage("image/space/space9_4-frames.png")
    self.frames = anim8.newGrid(320, 320, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.frames('1-4', 1), 0.5)
end

function Background:draw()
    love.graphics.setColor(1, 1, 1, .4)
    self.animation:draw(self.spriteSheet, 0, 0, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 320, 0, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 640, 0, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 960, 0, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 0, 320, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 320, 320, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 640, 320, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 960, 320, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 0, 640, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 320, 640, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 640, 640, 0, 1, 1)
    self.animation:draw(self.spriteSheet, 960, 640, 0, 1, 1)
end

function Background:update(dt)
    self.animation:update(dt)
end

return Background
