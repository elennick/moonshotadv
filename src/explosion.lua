local anim8 = require 'libs.anim8'
local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Explosion = class('Explosion', Entity)

function Explosion:initialize(x, y, lifetime, size, shouldMakeNoise)
    Entity.initialize(self, x, y)

    self.explSpriteSheet = love.graphics.newImage("image/explosion-animated.png")
    local explFrames = anim8.newGrid(16, 16, self.explSpriteSheet:getWidth(), self.explSpriteSheet:getHeight())
    self.explAnimation = anim8.newAnimation(explFrames('1-5', 1), 0.125)

    self.lifetime = lifetime
    self.size = size
    self.timeAlive = 0
    self.shouldMakeNoise = shouldMakeNoise

    if self.shouldMakeNoise then
        self.explSound = love.audio.newSource("audio/explosion.mp3", "static"):clone()
        self.explSound:setVolume(0.3)
        self.explSound:play()
    end
end

function Explosion:draw()
    self.explAnimation:draw(self.explSpriteSheet, self.x, self.y, 0, self.size, self.size, 16 / 2, 16 / 2)
end

function Explosion:update(dt)
    self.explAnimation:update(dt)
    self.timeAlive = self.timeAlive + dt
end

function Explosion:getTimeAlive()
    return self.timeAlive
end

function Explosion:getLifetime()
    return self.lifetime
end

function Explosion:destroy()
    if self.shouldMakeNoise then
        self.explSound:stop()
        self.explSound:release()
    end
end

return Explosion
