local class = require 'libs.middleclass'

Entity = class('Entity')

function Entity:initialize(x, y)
    self.x = x
    self.y = y
end

function Entity:getX()
    return self.x
end

function Entity:getY()
    return self.y
end

function Entity:getCoords()
    return self.x, self.y
end

return Entity
