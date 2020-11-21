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

function Entity:getVectorTowardPlayer()
    local vectorXTowardPlayer = self.x - player:getX()
    local vectorYTowardPlayer = self.y - player:getY()
    return vectorXTowardPlayer, vectorYTowardPlayer
end

function Entity:getRadiansTowardPlayer()
    local x, y = self:getVectorTowardPlayer()
    return math.atan2(y, x)
end

function Entity:destroy()
    --override if necessary
end

function Entity:update(dt)
    --override if necessary
end

function Entity:draw()
    --override if necessary
end

return Entity
