local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Key = class('Key', Entity)

function Key:initialize(x, y)
    Entity.initialize(self, x, y)
end

function Key:draw()
end

function Key:update(dt)
end

return Key
