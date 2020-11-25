local class = require 'libs.middleclass'
local Entity = require 'src.entity'

Key = class('Key', Entity)

function Key:initialize(args)
    Entity.initialize(self, args.x, args.y)

    self.keySheet = love.graphics.newImage("image/keysheet.png")
    self.keyQuad = love.graphics.newQuad(200, 90, 100, 150, self.keySheet:getWidth(), self.keySheet:getHeight())

    self.collider = world:newBSGRectangleCollider(self.x + 5, self.y + 10, 20, 40, 3)
    self.collider:setCollisionClass('Key')

    self.clonedKeyPickupSound = keyPickupSound:clone()
end

function Key:draw()
    love.graphics.draw(self.keySheet, self.keyQuad, self.x, self.y, 0, .5, .5)
end

function Key:update(dt)
    if self.collider:enter('Player') then
        self.clonedKeyPickupSound:play()
        player:addKeyToInventory()
        self.collider:destroy()
        keys = {}
    end
end

function Key:getBox()
    return self.collider
end

return Key
