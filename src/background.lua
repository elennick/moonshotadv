local class = require 'libs.middleclass'
local anim8 = require 'libs.anim8'

require 'src.meteor'

Background = class('Background')

local meteorsEnabled = false

function Background:initialize()
    self.spriteSheet = love.graphics.newImage("image/background.png")
    self.frames = anim8.newGrid(320, 320, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.frames('1-4', 1), 0.5)

    self.meteors = {}
end

function Background:draw()
    love.graphics.setColor(1, 1, 1, .3)
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

    love.graphics.setColor(1, 1, 1, 1)
    for i in ipairs(self.meteors) do
        self.meteors[i]:draw()
    end
end

function Background:update(dt)
    self.animation:update(dt)

    if meteorsEnabled then
        if (love.math.random(1, 1000) == 1) then
            print('generate meteor')
            table.insert(self.meteors, Meteor:new())
        end
    end

    for i in ipairs(self.meteors) do
        self.meteors[i]:update(dt)
        if self.meteors[i]:getX() > 1350 then
            self.meteors[i]:destroy()
            table.remove(self.meteors, i)
        end
    end
end

return Background
