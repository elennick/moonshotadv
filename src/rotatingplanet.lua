local class = require 'libs.middleclass'

RotatingPlanet = class('RotatingPlanet')

function RotatingPlanet:initialize(x, y, size, image, rotationSpeed)
    self.x = x
    self.y = y
    self.size = size
    self.image = image
    self.rotationSpeed = rotationSpeed
    self.rotation = 0
end

function RotatingPlanet:draw()
    love.graphics.draw(moonImage,
            self.x, self.y,
            self.rotation,
            self.size, self.size,
            self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function RotatingPlanet:update(dt)
    self.rotation = self.rotation + self.rotationSpeed
    if self.rotation > 360 then
        self.rotation = 0
    end
end

return RotatingPlanet
